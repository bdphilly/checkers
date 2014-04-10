require 'set'

$dictionary_words = Set.new(File.read("dictionary.txt").split)


def adjacent_words(word, dictionary)
	adjacents = []
	dictionary.each do |dict_word|
		adjacents << dict_word if adjacent?(word, dict_word)
	end
	adjacents
end

def adjacent?(word1, word2)
	return false if word1.length != word2.length
	different = 0
	word1.split('').each_with_index do |char, index|
		different += 1 if word2[index] != char
	end
	different == 1
end

def explore_words(source, dictionary)
	words_to_expand = [source]
	candidate_words = Set.new

	dictionary.each do |word|
		candidate_words << word if source.length == word.length
	end

	all_reachable_words = []

	until words_to_expand.empty?

		new_word = words_to_expand.shift

		adjacent_words(new_word, candidate_words).each do |adjacent_word|
			candidate_words.delete(adjacent_word)
			words_to_expand << adjacent_word
			all_reachable_words << adjacent_word
		end

	end
	all_reachable_words
end

def find_chain(source, target, dictionary)

	return nil unless source.length == target.length

	parents = {source => nil}

	words_to_expand = [source]
	candidate_words = Set.new

	dictionary.each do |word|
		candidate_words << word if source.length == word.length
	end

	candidate_words.delete(source)

	until words_to_expand.empty?

		new_word = words_to_expand.shift

		adjacent_words(new_word, candidate_words).each do |adjacent_word|
			candidate_words.delete(adjacent_word)
			words_to_expand << adjacent_word

			parents[adjacent_word] = new_word
			return parents if adjacent_word == target
		end
	end
	nil
end

def build_path_from_breadcrumbs(source, target)

	path = []

	parents = find_chain(source, target, $dictionary_words)
	puts parents
	key = target

	while key
		path << key
		key = parents[key]
	end

	path.reverse

end

# puts find_chain('abacy', 'block', $dictionary_words[0..5000])

puts build_path_from_breadcrumbs('duck', 'ruby')

