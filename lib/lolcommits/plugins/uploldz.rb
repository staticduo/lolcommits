require 'rest_client'

module Lolcommits
  class Uploldz < Plugin
    attr_accessor :endpoint

    def initialize(runner)
      super
      self.options << 'endpoint'
    end

    def run
      if !is_configured?
        puts "Missing #{self.class.name} config - configure with: lolcommits --config -p #{self.class.name}"
        return
      end

      repo = self.runner.repo.to_s
      if configuration['endpoint'].empty?
        puts "Endpoint URL is empty, please run 'lolcommits --config --plugin #{name}' to add one."
      elsif repo.empty?
        puts "Repo is empty, skipping upload"
      else
        debug "Calling " + configuration['endpoint'] + " with repo " + repo
        RestClient.post(configuration['endpoint'],
          :file => File.new(self.runner.main_image),
          :repo => repo)
      end
    end

    def is_configured?
      !configuration["enabled"].nil? && configuration["endpoint"]
    end

    def self.name
      'uploldz'
    end
  end
end
