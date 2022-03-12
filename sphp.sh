#!/bin/bash

# Creator: Phil Cook
# Modified: Andy Miller
# Modified: Thomas Isberg. Simplified the script to primarily work with macos-web-development.

# Has the user submitted a version required
if [[ -z "$1" ]]; then
    echo "No PHP version specified."
    echo "Run 'sphp {version}'"
    exit
fi

brew_prefix="$(brew --prefix)"
brew_prefix_escaped=$(echo "$brew_prefix" | sed 's#/#\\\/#g')

brew_array=("5.6","7.0","7.1","7.2","7.3","7.4","8.0","8.1")
php_array=("php@5.6" "php@7.0" "php@7.1" "php@7.2" "php@7.3" "php@7.4" "php@8.0" "php@8.1")
php_version="php@$1"
php_version_numeric=$(echo "$php_version" | sed 's/^php@//' | sed 's/\.//')
php_opt_path="$brew_prefix_escaped\/opt\/"

php5_module="php5_module"
apache_php5_lib_path="\/lib\/httpd\/modules\/libphp5.so"
php7_module="php7_module"
apache_php7_lib_path="\/lib\/httpd\/modules\/libphp7.so"
php8_module="php_module"
apache_php8_lib_path="\/lib\/httpd\/modules\/libphp.so"

php_module="$php5_module"
apache_php_lib_path="$apache_php5_lib_path"

if [[ $php_version_numeric -ge 80 ]]; then
    php_module="$php8_module"
    apache_php_lib_path="$apache_php8_lib_path"
elif [[ $php_version_numeric -ge 70 ]]; then
    php_module="$php7_module"
    apache_php_lib_path="$apache_php7_lib_path"
fi

apache_conf_path="$brew_prefix/etc/httpd/httpd.conf"
apache_php_mod_path="$php_opt_path$php_version$apache_php_lib_path"

# Check that the requested version is supported.
if [[ " ${php_array[*]} " == *"$php_version"* ]]; then
    # Check that the requested version is installed.
    if [[ -n "$(brew ls --versions "$php_version")" ]]; then
        # Require sudo
        echo "Acquire sudo ..."
        sudo echo "" > /dev/null
        echo ""

        php_executable="$(command -v php)"
        php_executable_path=""
        php_linked=""
        if [[ ! -z "$php_executable" ]]; then
            php_executable_path="$(ls -la $php_executable)"
        fi
        if [[ ! -z "$php_executable_path" ]]; then
            php_linked="$(echo "$php_executable_path" | sed -E 's#^.*/php(@[^/]+)?/.*$#php\1#')"
            if [[ ! $php_linked =~ ^php(@[0-9]\.[0-9])?$ ]]; then
                echo "Could not figure out current PHP version – it looks weird:"
                echo "$php_linked"
                echo "Please disable the current PHP version manually, by running:"
                echo "brew unlink {php_version}"
                echo "Then run this switcher again."
                exit
            fi
        fi

        # Switch PHP version.
        if [[ "$php_linked" == "$php_version" ]]; then
            echo "You already use $php_version."
        else
            if [[ ! -z "$php_linked" ]]; then
                echo "Disabling $php_linked ..."
                brew unlink "$php_linked"
                echo "Disabled $php_linked."
                echo ""
            fi

            echo "Enabling $php_version ..."
            brew link --force --overwrite "$php_version"
            echo "Enabled $php_version."
            echo ""
        fi

        # Switch apache
        echo "Configuring Apache ..."

        # Make sure all PHP modules are available and commented in Apache config.
        for j in ${php_array[@]}; do
            loop_php_module="$php5_module"
            loop_apache_php_lib_path="$apache_php5_lib_path"
            loop_php_version_numeric=$(echo "$j" | sed 's/^php@//' | sed 's/\.//')
            if [ $loop_php_version_numeric -ge 80 ]; then
                loop_php_module="$php8_module"
                loop_apache_php_lib_path="$apache_php8_lib_path"
            elif [ $loop_php_version_numeric -ge 70 ]; then
                loop_php_module="$php7_module"
                loop_apache_php_lib_path="$apache_php7_lib_path"
            fi
            apache_module_string="LoadModule $loop_php_module $php_opt_path$j$loop_apache_php_lib_path"
            comment_apache_module_string="#$apache_module_string"

            # If apache module string within apache conf
            if grep -q "$apache_module_string" "$apache_conf_path"; then
                # If apache module string not commented out already
                if ! grep -q "$comment_apache_module_string" "$apache_conf_path"; then
                    sudo sed -i.bak "s/$apache_module_string/$comment_apache_module_string/g" $apache_conf_path
                fi
            # Else the string for the php module is not in the apache config then add it
            else
                sudo sed -i.bak "/LoadModule rewrite_module lib\/httpd\/modules\/mod_rewrite.so/a\\
$comment_apache_module_string\\
" $apache_conf_path
            fi
        done

        # Activate (uncomment) the desired PHP module in Apache config.
        sudo sed -i.bak "s/\#LoadModule $php_module $apache_php_mod_path/LoadModule $php_module $apache_php_mod_path/g" $apache_conf_path

        echo "Apache configured."
        echo ""

        echo "Restarting Apache ..."
        # sudo apachectl -k restart
        brew services restart httpd
        echo "Apache restarted."
        echo ""

        php -v
        echo ""
        echo "All done!"
    else
        echo "Sorry, but $php_version is not installed via brew. Install by running: brew install $php_version"
    fi
else
    echo "Unknown version of PHP. PHP Switcher can only handle arguments of:" ${brew_array[@]}
fi
