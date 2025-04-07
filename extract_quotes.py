import spacy
import sys

def extract_quotes(input_file, output_file):
	nlp = spacy.load("en_core_web_sm")
	with open(input_file, "r") as f:
		text = f.read()
	doc = nlp(text)
	quotes = []
	for sent in doc.sents:
		if '"' in sent.text or "'" in sent.text:
			quotes.append(sent.text)
	with open(output_file, "w") as f:
		for quote in quotes:
			f.write(quote + "\n")

if __name__ == "__main__":
	input_file = sys.argv[1]
	output_file = sys.argv[2]
	extract_quotes(input_file, output_file)