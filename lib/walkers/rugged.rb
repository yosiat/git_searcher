require "rugged"
require "linguist"
require "lib/linguist/rugged_blob_helper"

module Rugged
	class GitRepositoryWalker
		def self.include_linguistic
			Rugged::OdbObject.class_eval { include Linguist::RuggedBlobHelper }
		end

		def self.initialize_repository directory
			Rugged::Repository.new(directory)
		end

		def self.get_tree repository, ref, ref_type
			target = case ref_type
						when :branch
							Rugged::Reference.lookup(repository, ref).target
						when :commit_id
							ref
					end


			repository.lookup(target).tree
		end

		def self.walk_tree(repository, tree, &block)
			tree.each_blob { |blob| block.call(get_blob(repository, blob)) }
			tree.each_tree { |_tree| walk_tree repository, repository.lookup(_tree[:oid]), &block }
		end

private
		def self.get_blob repository, blob
			object = repository.read(blob[:oid])
			object.name = blob[:name]

			object
		end
	end
end


