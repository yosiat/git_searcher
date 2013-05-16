require "json"

class RepositoryBloblWalker
	def initialize directory, walker
		RepositoryBloblWalker.class_eval do
			include Kernel.const_get(walker)
			GitRepositoryWalker.include_linguistic
		end

		@repository = GitRepositoryWalker.initialize_repository(directory)
		@directory = directory
	end

	def walk ref, ref_type, &block
		@block = block
		walk_tree GitRepositoryWalker.get_tree @repository, ref, ref_type
	end

private
	

	def walk_tree tree
		GitRepositoryWalker.walk_tree(@repository, tree) do |blob|
			index_blob blob
		end
	end


	def index_blob object
		language = []
		language = [object.language.aliases, object.language.search_term].flatten unless object.language.nil?
		
		index = {
			:blob_size => object.size,
			:path => object.name,
			:repository => @directory,
			:language => language,
			:mime_type => object.mime_type,
			:loc => object.loc,
			:code => object.data
		}

		@block.call(index)
	end
end
