require 'open3'
require 'byebug'
require 'date'

def get_git_data
  stdout, stderr, status = Open3.capture3(
    [
      "git rev-list",
      "HEAD",
      "--no-commit-header",
      "--format=format:' %H %at %s'",
      "--objects",
      "--in-commit-order",
      "--",
      "_lectures/*.md",
      "_nodes/*.md",
    ].join(" "),
  )
  stdout
end

def parse_git_data(data)
  [].tap do |changelog|
    data.lines.map do |line|
      case line
      # commit objects are detected by leading space
      when /^ /
        hash, timestamp, subject = line.strip.split(' ', limit=3)
        changelog << {
          "hash" => hash,
          "timestamp" => Time.at(timestamp.to_i),
          "subject" => subject,
          "nodes" => [],
        }
      # interesting blob objects are detected by path
      when /^[0-9a-f]{40} (?<file>_(lectures|nodes)\/.+\.md)$/
        changelog.last.fetch("nodes") << Regexp.last_match[:file]
      end
    end
    changelog.each_cons(2) { |(a,b)| a["nodes"] = b["nodes"] }
    changelog.pop
  end
end

module Changelog
  class Generator < Jekyll::Generator
    def generate(site)
      nodes = site.collections.values_at("nodes", "lectures").flat_map(&:docs)
      changelog = site.pages.find { |page| page.relative_path == "changelog.md" }
      commits = parse_git_data(get_git_data)
      commits.each do |commit|
        commit["nodes"].map! do |path|
          nodes.find { |node| node.relative_path == path }
        end
      end
      changelog.data['commits'] = commits
    end
  end
end
