#! /bin/bash
# Creates a skeleton module 
prompt "module" "Module shortname " "tempModule"
prompt "title" "Module Full Name" "Module Name Placeholder"
prompt "description" "Module description" "A short description"
prompt "package" "Package name " "Earth Research Institute"
prompt "core" "Core " "7.x"
prompt "version" "Version" "7.x-1.0"

function module_info
{
  cat <<- _EOF_
name               = "$module"
description        = "$description"
core               = "$core"
package            = "$package"
version            = "$core-1.0"

scripts[]          = "js/$module.js"
stylesheets[all][] = "css/$module.css"
_EOF_
}
#INSTALL FILE
function install_file
{
    cat <<- _EOF_
<?php
/**
 * @file
 * Install file for $module
 */

/** Implements hook_install() */
function ${module}_install() {

}
/** Implements hook_uninstall() */
function ${module}_uninstall() {

}
/** Implements hook_schema() */
function ${module}_schema() {
  \$schema = array();

  \$schema['$module'] = array(
    'fields' => array(
      'id' => array(
        'description' => 'Primary identifier'
        'type'        => 'serial',
        'unsigned'    => TRUE,
        'not null'    => TRUE,
        ),
      ),
    'primary key' = array('id'),
    );
  return(\$schema);
}
_EOF_
}
#MODULE FILE
function module_file
{
  cat <<- _EOF_
<?php
/**
 * @file
 * $description
 */

/** 
 * Implements hook_menu()
 */
function ${module}_menu() {
  \$items = array();
  \$items[''] = array(
    'title'            => '$module',
    'page callback'    => '${module}_main_menu',
    'access arguments' => 'administer content',
    'type'             => MENU_NORMAL_ITEM
    );
  return(\$items);
}
/**
 * Builds main menu for $module
 */
function ${module}_main_menu() {
  \$template_args = array();
  \$page = theme('$module', array('fields' => \$template_args));

  return(\$page);
}
/**
 * Implements hook_theme()
 * Default module theme template
 */
function ${module}_theme() {
  \$themes['$module'] = array(
    'template'  => "templates/$module",
    'arguments' => array('fields' => NULL)
  );
  return(\$themes);
}
_EOF_
}
#JS FILE
function js_file
  {
       cat <<- _EOF_
/**
 * @file
 * Core javascript for $module module.
 */

Drupal.behaviors.$module = {
  attach: function() {
    
  }
};
_EOF_
}
#CSS FILE
function css_file 
{
  cat <<- _EOF_
/**
 * @file
 * Core styles for $module module.
 */
_EOF_
}
#TEMPLATE FILE
function template_file
{
  cat <<- _EOF_
<?php
/**
 * @file
 * Main template for $module module.
 */
?>
<div id="$module-main-wrapper">
</div>
_EOF_
}

#BUILD MODULE BIOILERPLATE
echo "Making directory $module..."
mkdir $module

echo "Making templates, css, and js dirs..."
mkdir $module/'templates'
mkdir $module/'css'
mkdir $module/'js'

echo "Creating files $module.info, $module.module and others..."
touch $module/$module.info
touch $module/$module.module
touch $module/$module.install
touch $module/js/$module.js
touch $module/css/$module.css
touch $module/templates/$module.tpl.php

echo "Writing to files..."
module_info   > $module/$module.info
module_file   > $module/$module.module
install_file  > $module/$module.install
js_file       > $module/js/$module.js
css_file      > $module/css/$module.css
template_file > $module/templates/$module.tpl.php

echo "Writing permissions..."
chown -R $USER $module

echo "YOUR MODULE IS READY!"