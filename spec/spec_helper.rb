require "bundler/setup"
Bundler.require(:test)

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require "m/all"
require "shared/monad_laws"
