grammarinator-process ../acme.g4 -o <output-directory> --no-actions
grammarinator-generate -p acmeUnparser.py -l acmeUnlexer.py  -n 100 -t grammarinator.runtime.simple_space_transformer -o tests/test_%d.abnf

