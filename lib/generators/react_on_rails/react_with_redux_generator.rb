# frozen_string_literal: true

require "rails/generators"

module ReactOnRails
  module Generators
    class ReactWithReduxGenerator < Rails::Generators::Base
      Rails::Generators.hide_namespace(namespace)
      source_root(File.expand_path("templates", __dir__))

      def create_redux_directories
        dirs = %w[actions constants containers reducers store startup]
        dirs.each { |name| empty_directory("#{CLIENT_BASE_PATH}/bundles/HelloWorld/#{name}") }
      end

      def copy_base_files
        base_js_path = "redux/base/#{CLIENT_BASE_PATH}"
        base_files = %w[bundles/HelloWorld/components/HelloWorld.jsx]
        base_files.each { |file| copy_file("#{base_js_path}/#{file}", "#{CLIENT_BASE_PATH}/#{file}") }
      end

      def copy_base_redux_files
        base_hello_world_path = "redux/base/#{CLIENT_BASE_PATH}/bundles/HelloWorld"
        %w[actions/helloWorldActionCreators.js
           containers/HelloWorldContainer.js
           constants/helloWorldConstants.js
           reducers/helloWorldReducer.js
           store/helloWorldStore.js
           startup/HelloWorldApp.jsx].each do |file|
             copy_file("#{base_hello_world_path}/#{file}",
                       "#{CLIENT_BASE_PATH}/bundles/HelloWorld/#{file}")
           end
      end

      def create_appropriate_templates
        base_path = "base/base"
        base_js_path = "#{base_path}/#{CLIENT_BASE_PATH}"
        config = {
          component_name: "HelloWorldApp",
          app_relative_path: "../bundles/HelloWorld/startup/HelloWorldApp"
        }

        template("#{base_js_path}/packs/registration.js.tt", "#{CLIENT_BASE_PATH}/packs/hello-world-bundle.js", config)
        template("#{base_path}/app/views/hello_world/index.html.erb.tt", "app/views/hello_world/index.html.erb", config)
      end

      def add_redux_yarn_dependencies
        run "yarn add redux react-redux"
      end
    end
  end
end
