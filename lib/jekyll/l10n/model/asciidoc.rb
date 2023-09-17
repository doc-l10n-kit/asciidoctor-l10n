# frozen_string_literal: true

require 'asciidoctor/document'
require 'asciidoctor/table'
require_relative 'sentence'
require_relative 'document_title'
require_relative 'block_title'
require_relative 'section_title'
require_relative 'table_title'
require_relative 'list_title'
require_relative 'block'
require_relative 'cell'
require_relative 'list_item'


module Jekyll
  module L10n
    module Model
      class Asciidoc
        def initialize(document)
          @document = document
        end

        def extract_sentences
          sentences = []

          walk_node(@document, sentences)


          sentences
        end

        private def walk_node(node, sentences)
          if node.is_a? Array
            node.each do |item|
              walk_node(item, sentences)
            end
            return nil
          end
          if node.is_a? Asciidoctor::Document
            node.blocks.each do |block|
              walk_node(block, sentences)
            end
            return nil
          end
          if node.is_a? Asciidoctor::Section
            sentence = SectionTitle.new(node)
            if sentence.text != nil && sentence.text.empty? == false
              sentences.append(sentence)
            end
            node.blocks.each do |block|
              walk_node(block, sentences)
            end
            return nil
          end
          if node.is_a? Asciidoctor::Block
            # title
            sentence = BlockTitle.new(node)
            if sentence.text != nil && sentence.text.empty? == false
              sentences.append(sentence)
            end

            # body
            sentence = Block.new(node)
            if sentence.text != nil && sentence.text.empty? == false && sentence.node.style != 'source'
              sentences.append(sentence)
            end
            node.blocks.each do |block|
              walk_node(block, sentences)
            end
            return nil
          end
          if node.is_a? Asciidoctor::Table
            sentence = TableTitle.new(node)
            if sentence.text != nil && sentence.text.empty? == false
              sentences.append(sentence)
            end
            node.rows.head.each do |cell|
              walk_node(cell, sentences)
            end
            node.rows.body.each do |cell|
              walk_node(cell, sentences)
            end
            node.rows.foot.each do |cell|
              walk_node(cell, sentences)
            end
            return nil
          end
          if node.is_a? Asciidoctor::Table::Cell
            sentence = Cell.new(node)
            if sentence.text != nil && sentence.text.empty? == false
              sentences.append(sentence)
            end
            node.blocks.each do |block|
              walk_node(block, sentences)
            end
            return nil
          end
          if node.is_a? Asciidoctor::List
            sentence = ListTitle.new(node)
            if sentence.text != nil && sentence.text.empty? == false
              sentences.append(sentence)
            end
            node.blocks.each do |block|
              walk_node(block, sentences)
            end
            return nil
          end
          if node.is_a? Asciidoctor::ListItem
            sentence = ListItem.new(node)
            if sentence.text != nil && sentence.text.empty? == false
              sentences.append(sentence)
            end
            node.blocks.each do |block|
              walk_node(block, sentences)
            end
            return nil
          end

          node
        end


      end
    end
  end
end

