require ::File.dirname(__FILE__) + '/config/boot.rb'
run Padrino.application
require 'sass/plugin/rack'
use Sass::Plugin::Rack