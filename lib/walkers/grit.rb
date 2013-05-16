$LOAD_PATH << File.dirname(__FILE__)

require "grit"
require "linguist"

module Grit
	class GitRepositoryWalker
		def self.include_linguistic
			Grit::Blob.class_eval { include Linguist::BlobHelper } 
		end

		def self.initialize_repository directory
			Grit::Repo.new(directory)
		end

		def self.get_tree repository, ref, ref_type
			repository.commits(ref).first.tree
		end

		def self.walk_tree(repository, tree, &block)

			tree.contents.each do |content|
				case content
					when Grit::Blob
						block.call(content)
					when Grit::Tree
						walk_tree repository, content, &block
				end
			end
		end
	end
end