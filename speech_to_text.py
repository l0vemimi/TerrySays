import speech_recognition as sr

# Initialize the recognizer
recognizer = sr.Recognizer()


# Load the audio file
audio_file_path = "path_to_your_audio_file.wav"  # Replace with your audio file path

try:
    # Open the audio file
    with sr.AudioFile(audio_file_path) as source:
        print("Processing audio...")
        audio_data = recognizer.record(source)  # Read the entire audio file

    # Recognize speech using Google's Web Speech API
    text = recognizer.recognize_google(audio_data)
    print("Transcription:")
    print(text)

except sr.UnknownValueError:
    print("Speech Recognition could not understand the audio.")
except sr.RequestError as e:
    print(f"Could not request results from Google Speech Recognition service; {e}")
except FileNotFoundError:
    print("Audio file not found. Please check the file path.")