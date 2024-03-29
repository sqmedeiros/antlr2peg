# Generated by Grammarinator 19.3

from itertools import chain
from grammarinator.runtime import *

import AbnfUnlexer


class AbnfUnparser(Grammarinator):

    def __init__(self, unlexer):
        super(AbnfUnparser, self).__init__()
        self.unlexer = unlexer
    @depthcontrol
    def rulelist(self):
        current = self.create_node(UnparserRule(name='rulelist'))
        if self.unlexer.max_depth >= 7:
            for _ in self.zero_or_more():
                current += self.rule_()

        current += self.unlexer.EOF()
        return current
    rulelist.min_depth = 1

    @depthcontrol
    def rule_(self):
        current = self.create_node(UnparserRule(name='rule_'))
        current += self.unlexer.ID()
        current += self.create_node(UnlexerRule(src='='))
        if self.unlexer.max_depth >= 0:
            for _ in self.zero_or_one():
                current += self.create_node(UnlexerRule(src='/'))

        current += self.elements()
        return current
    rule_.min_depth = 6

    @depthcontrol
    def elements(self):
        current = self.create_node(UnparserRule(name='elements'))
        current += self.alternation()
        return current
    elements.min_depth = 5

    @depthcontrol
    def alternation(self):
        current = self.create_node(UnparserRule(name='alternation'))
        current += self.concatenation()
        if self.unlexer.max_depth >= 4:
            for _ in self.zero_or_more():
                current += self.create_node(UnlexerRule(src='/'))
                current += self.concatenation()

        return current
    alternation.min_depth = 4

    @depthcontrol
    def concatenation(self):
        current = self.create_node(UnparserRule(name='concatenation'))
        if self.unlexer.max_depth >= 0:
            for _ in self.one_or_more():
                current += self.repetition()

        return current
    concatenation.min_depth = 3

    @depthcontrol
    def repetition(self):
        current = self.create_node(UnparserRule(name='repetition'))
        if self.unlexer.max_depth >= 1:
            for _ in self.zero_or_one():
                current += self.repeat()

        current += self.element()
        return current
    repetition.min_depth = 2

    @depthcontrol
    def repeat(self):
        current = self.create_node(UnparserRule(name='repeat'))
        choice = self.choice([0 if [1, 0][i] > self.unlexer.max_depth else w * self.unlexer.weights.get(('alt_72', i), 1) for i, w in enumerate([1, 1])])
        self.unlexer.weights[('alt_72', choice)] = self.unlexer.weights.get(('alt_72', choice), 1) * self.unlexer.cooldown
        if choice == 0:
            current += self.unlexer.INT()
        elif choice == 1:
            if self.unlexer.max_depth >= 1:
                for _ in self.zero_or_one():
                    current += self.unlexer.INT()

            current += self.create_node(UnlexerRule(src='*'))
            if self.unlexer.max_depth >= 1:
                for _ in self.zero_or_one():
                    current += self.unlexer.INT()

        return current
    repeat.min_depth = 0

    @depthcontrol
    def element(self):
        current = self.create_node(UnparserRule(name='element'))
        choice = self.choice([0 if [2, 6, 6, 1, 3, 1][i] > self.unlexer.max_depth else w * self.unlexer.weights.get(('alt_78', i), 1) for i, w in enumerate([1, 1, 1, 1, 1, 1])])
        self.unlexer.weights[('alt_78', choice)] = self.unlexer.weights.get(('alt_78', choice), 1) * self.unlexer.cooldown
        if choice == 0:
            current += self.unlexer.ID()
        elif choice == 1:
            current += self.group()
        elif choice == 2:
            current += self.option()
        elif choice == 3:
            current += self.unlexer.STRING()
        elif choice == 4:
            current += self.unlexer.NumberValue()
        elif choice == 5:
            current += self.unlexer.ProseValue()
        return current
    element.min_depth = 1

    @depthcontrol
    def group(self):
        current = self.create_node(UnparserRule(name='group'))
        current += self.create_node(UnlexerRule(src='('))
        current += self.alternation()
        current += self.create_node(UnlexerRule(src=')'))
        return current
    group.min_depth = 5

    @depthcontrol
    def option(self):
        current = self.create_node(UnparserRule(name='option'))
        current += self.create_node(UnlexerRule(src='['))
        current += self.alternation()
        current += self.create_node(UnlexerRule(src=']'))
        return current
    option.min_depth = 5

    default_rule = rulelist

