# List of locales supported by Amazon translator for LocalizationEditor : MIT License
# @author Vladimir Petrenko
# @see https://aws.amazon.com/translate/
class_name LocalizationAutoTranslateAmazon

const LOCALES = {
	"af": "Afrikaans",
	"sq": "Albanian",
	"am": "Amharic",
	"ar": "Arabic",
	"hy": "Armenian",
	"az": "Azerbaijani",
	"bn": "Bengali",
	"bs": "Bosnian",
	"bg": "Bulgarian",
	"ca": "Catalan",
	"zh": "Chinese (Simplified)",
	"zh-TW": "Chinese (Traditional)",
	"hr": "Croatian",
	"cs": "Czech",
	"da": "Danish",
	"fa-AF": "Dari",
	"nl": "Dutch",
	"en": "English",
	"et": "Estonian",
	"fa": "Farsi (Persian)",
	"tl": "Filipino, Tagalog",
	"fi": "Finnish",
	"fr": "French",
	"fr-CA": "French (Canada)",
	"ka": "Georgian",
	"de": "German",
	"el": "Greek",
	"gu": "Gujarati",
	"ht": "Haitian Creole",
	"ha": "Hausa",
	"he": "Hebrew",
	"hi": "Hindi",
	"hu": "Hungarian",
	"is": "Icelandic",
	"id": "Indonesian",
	"ga": "Irish",
	"it": "Italian",
	"ja": "Japanese",
	"kn": "Kannada",
	"kk": "Kazakh",
	"ko": "Korean",
	"lv": "Latvian",
	"lt": "Lithuanian",
	"mk": "Macedonian",
	"ms": "Malay",
	"ml": "Malayalam",
	"mt": "Maltese",
	"mr": "Marathi",
	"mn": "Mongolian",
	"no": "Norwegian (Bokmål)",
	"ps": "Pashto",
	"pl": "Polish",
	"pt": "Portuguese (Brazil)",
	"pt-PT": "Portuguese (Portugal)",
	"pa": "Punjabi",
	"ro": "Romanian",
	"ru": "Russian",
	"sr": "Serbian",
	"si": "Sinhala",
	"sk": "Slovak",
	"sl": "Slovenian",
	"so": "Somali",
	"es": "Spanish",
	"es-MX": "Spanish (Mexico)",
	"sw": "Swahili",
	"sv": "Swedish",
	"ta": "Tamil",
	"te": "Telugu",
	"th": "Thai",
	"tr": "Turkish",
	"uk": "Ukrainian",
	"ur": "Urdu",
	"uz": "Uzbek",
	"vi": "Vietnamese",
	"cy": "Welsh"
}

static func label_by_code(code: String) -> String:
	if LOCALES.has(code.to_lower()):
		return code + " " + LOCALES[code.to_lower()]
	return ""
