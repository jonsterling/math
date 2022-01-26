require 'open3'
require 'date'

module Changelog
  class Generator < Jekyll::Generator
    NODES_COLLECTIONS_NAMES = ["nodes", "lectures"]
    NODES_COLLECTION_PATHS = ["_lectures/", "_nodes/"]
    CHANGELOG_PAGE_PATH = "changelog.md"

    def generate(site)
      nodes = site.collections.values_at(*NODES_COLLECTIONS_NAMES).flat_map(&:docs)
      changelog = site.pages.find { |page| page.relative_path == CHANGELOG_PAGE_PATH }
      authors = site.config.fetch("changelog", {}).fetch("authors", {})
      commits = parse_git_data(get_git_data, authors)
      commits.each do |commit|
        commit["diffs"].each do |diff|
          diff["node"] = nodes.find do |node|
            node.relative_path == diff["path"]
          end
        end
      end
      changelog.data['commits'] = commits
    end

    def get_git_data
      stdout, stderr, status = Open3.capture3(
        [
          "git log",
          "--pretty='format:#{%w{%H %at %aN %aE %s}.join('%x00')}'",
          # we're interested in ADM of files (not Rs or Cs)
          "--name-status",
          "--no-renames",
          "--diff-filter=ADM",
          # we match folders to get deleted objects too
          "--",
          *NODES_COLLECTION_PATHS,
        ].join(" "),
      )
      stdout
    end

    def parse_git_data(data, authors)
      [].tap do |changelog|
        data.split("\n\n").each do |block|
          commit, *diff = block.split("\n")
          hash, timestamp, name, mail, subject = commit.split("\u0000")
          changelog << {
            "hash" => hash,
            "timestamp" => Time.at(timestamp.to_i),
            "subject" => subject,
            "diffs" => [],
            "author" => {
              "name" => name,
              "mail" => mail,
            }.merge(authors.fetch(mail, {})),
          }
          diff.each do |line|
            status, path = line.split("\t")
            changelog.last.fetch("diffs") << {
              "status" => status,
              "path" => path,
            }
          end
        end
      end
    end
  end
end
