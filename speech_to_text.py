import speech_recognition as sr
import sys

def transcribe_audio(audio_file, output_file):
	recognizer = sr.Recognizer()
	with sr.AudioFile(audio_file) as source:
		audio = recognizer.record(source)
	try:
		text = recognizer.recognize_google(audio)
		with open(output_file, "w") as f:
			f.write(text)
	except sr.RequestError:
		with open(output_file, "w") as f:
			f.write("API unavailable")
	except sr.UnknownValueError:
		with open(output_file, "w") as f:
			f.write("Unable to recognize speech")

if __name__ == "__main__":
	audio_file = sys.argv[1]
	output_file = sys.argv[2]
	transcribe_audio(audio_file, output_file)