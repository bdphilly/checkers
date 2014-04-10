require 'set'

=begin
  Man is born free, and everywhere he is in chains.
=end

module WordChainer
  extend self

  def run(source, target, dictionary_file_name)
    dictionary = File.readlines(dictionary_file_name).map(&:chomp)

    # speed it up using a set
    dictionary = Set.new(dictionary)

    # build parents chain
    parents = find_chain(source, target, dictionary)

    parents && build_path_from_breadcrumbs(parents, source, target, dictionary)
  end

  def build_path_from_breadcrumbs(parents, source, target, dictionary)
    chain_word = target
    path = []

    # will stop after `source`, which is the only word with `nil`
    # parent
    while chain_word
      path << chain_word
      chain_word = parents[chain_word]
    end

    path.reverse
  end

  def find_chain(source, target, dictionary)
    return nil unless source.length == target.length

    # winnow the dictionary to words of same length
    candidate_words = dictionary.select { |word| word.length == source.length }

    # speed it up using a set
    candidate_words = Set.new(candidate_words)

    # do not revisit the source
    candidate_words.delete(source)

    # words we've reached in the previous round; we'll grow from these
    # each round. Start from the source.
    words_to_expand = [source]

    # map each word to the word we found it from; `source` has no
    # parent
    parents = {source => nil}

    # keep performing search steps until we find the target, or can't
    # find any new words
    until words_to_expand.empty?
      word_to_expand = words_to_expand.shift

      adjacent_words(word_to_expand, candidate_words).each do |adjacent_word|

        # don't revisit this word again
        candidate_words.delete(adjacent_word)

        # expand this word in the future
        words_to_expand << adjacent_word

        # record where it came from
        parents[adjacent_word] = word_to_expand

        # whoa! stop if we found the target word!
        return parents if adjacent_word == target
      end
    end

    nil
  end

  def adjacent_words(word, dictionary)
    # variable name *masks* (hides) method name; references inside
    # `adjacent_words` to `adjacent_words` will refer to the variable,
    # not the method. This is common, because side-effect free methods
    # are often named after what they return.
    adjacent_words = []

    # NB: I gained a big speedup by checking to see if small
    # modifications to the word were in the dictionary, vs checking
    # every word in the dictionary to see if it was "one away" from
    # the word. Can you think about why?
    word.each_char.with_index do |old_letter, i|
      ('a'..'z').each do |new_letter|
        # Otherwise we'll include the original word in the adjacent word array
        next if old_letter == new_letter

        new_word = word.dup
        new_word[i] = new_letter

        adjacent_words << new_word if dictionary.include?(new_word)
      end
    end

    adjacent_words
  end
end

puts WordChainer.run("duck", "ruby", "dictionary.txt")