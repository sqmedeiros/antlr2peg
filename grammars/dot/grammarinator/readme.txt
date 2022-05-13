grammarinator-process ../DOT.g4 -o <output-directory> --no-actions
grammarinator-generate -p DOTUnparser.py -l DOTUnlexer.py  -n 100 -t grammarinator.runtime.simple_space_transformer -o tests/test_%d.dot
