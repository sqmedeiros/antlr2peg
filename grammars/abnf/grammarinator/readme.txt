grammarinator-process ../Abnf.g4 -o <output-directory> --no-actions
grammarinator-generate -p AbnfUnparser.py -l AbnfUnlexer.py  -n 100 -t grammarinator.runtime.simple_space_transformer -o tests/test_%d.abnf
