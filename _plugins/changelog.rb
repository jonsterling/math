require 'open3'
require 'byebug'
require 'date'

def get_git_data
  stdout, stderr, status = Open3.capture3(
    [
      "git log",
      "--pretty='format:%H %at %s'",
      "--name-status",
      "--no-renames",
      "--diff-filter=ADM",
      "--",
      "_lectures/*.md",
      "_nodes/*.md",
    ].join(" "),
  )
  stdout
end

def parse_git_data(data)
  [].tap do |changelog|
    data.split("\n\n").each do |block|
      commit, *diff = block.split("\n")
      hash, timestamp, subject = commit.split(' ', limit=3)
      changelog << {
        "hash" => hash,
        "timestamp" => Time.at(timestamp.to_i),
        "subject" => subject,
        "diffs" => [],
      }
      diff.each do |line|
        status, path = line.split("\t")
        changelog.last.fetch("diffs") << { "status" => status, "path" => path }
      end
    end
  end
end

module Changelog
  class Generator < Jekyll::Generator
    def generate(site)
      nodes = site.collections.values_at("nodes", "lectures").flat_map(&:docs)
      changelog = site.pages.find { |page| page.relative_path == "changelog.md" }
      commits = parse_git_data(get_git_data)
      commits.each do |commit|
        commit["diffs"].each do |diff|
          diff["node"] = nodes.find do |node|
            node.relative_path == diff["path"]
          end
        end
      end
      changelog.data['commits'] = commits
    end
  end
end
