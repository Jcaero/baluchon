//
//  GoogleLanguage.swift
//  baluchon
//
//  Created by pierrick viret on 28/08/2023.
//

import Foundation

enum GoogleLanguage {

    case language(String)

    var complete: String {
        switch self {
        case.language(let code):
            guard let completLanguage = languageCodes[code] else {return "Anglais"}
            return completLanguage
        }
    }

    var code: String {
        switch self {
        case.language(let name):
            guard let codeLanguage = languageNames[name] else {return "en"}
            return codeLanguage
        }
    }
}

let languageNames = Dictionary(uniqueKeysWithValues: languageCodes.map({($1, $0)}))

let languageCodes: [String: String] = [
        "af": "Afrikaan",
        "sq": "Albanais",
        "am": "Amharique",
        "hy": "Arménien",
        "as": "Assamais",
        "ay": "Aymara",
        "az": "Azéri",
        "bm": "Bambara",
        "eu": "Basque",
        "be": "Biélorusse",
        "bn": "Bengalî",
        "bho": "Bhodjpouri",
        "bs": "Bosniaque",
        "bg": "Bulgare",
        "ca": "Catalan",
        "ceb": "Cebuano",
        "zh-CN": "Chinois",
        "co": "Corse",
        "hr": "Croate",
        "cs": "Tchèque",
        "da": "Danois",
        "dv": "Divéhi",
        "doi": "Dogri",
        "nl": "Néerlandais",
        "en": "Anglais",
        "eo": "Espéranto",
        "et": "Estonien",
        "ee": "Ewe",
        "fil": "Filipino",
        "fi": "Finnois",
        "fr": "Français",
        "fy": "Frison",
        "gl": "Galicien",
        "ka": "Géorgien",
        "de": "Allemand",
        "el": "Grec",
        "gn": "Guarani",
        "gu": "Gujarâtî",
        "ht": "Créole haïtien",
        "ha": "Haoussa",
        "haw": "Hawaïen",
        "he": "Hébreu",
        "hi": "Hindi",
        "hmn": "Hmong",
        "hu": "Hongrois",
        "is": "Islandais",
        "ig": "Igbo",
        "ilo": "Ilocano",
        "id": "Indonésien",
        "ga": "Irlandais",
        "it": "Italien",
        "ja": "Japonais",
        "jv": "Javanais",
        "kn": "Kannara",
        "kk": "Kazakh",
        "km": "Khmer",
        "rw": "Kinyarwanda",
        "gom": "Konkani",
        "ko": "Coréen",
        "kri": "Krio",
        "ku": "Kurde",
        "ky": "Kirghyz",
        "lo": "Laotien",
        "la": "Latin",
        "lv": "Letton",
        "ln": "Lingala",
        "lt": "Lituanien",
        "lg": "Luganda",
        "lb": "Luxembourgeois",
        "mk": "Macédonien",
        "mai": "Maithili",
        "mg": "Malgache",
        "ms": "Malais",
        "ml": "Malayâlam",
        "mt": "Maltais",
        "mi": "Maori",
        "mr": "Marathi",
        "mni-Mtei": "Meitei",
        "lus": "Mizo",
        "mn": "Mongol",
        "my": "Birman",
        "ne": "Népalais",
        "no": "Norvégien",
        "ny": "Nyanja",
        "or": "Odia",
        "om": "Oromo",
        "ps": "Pachtô",
        "fa": "Perse",
        "pl": "Polonais",
        "pt": "Portugais",
        "pa": "Panjabi",
        "qu": "Quechua",
        "ro": "Roumain",
        "ru": "Russe",
        "sm": "Samoan",
        "sa": "Sanskrit",
        "gd": "Gaélique",
        "nso": "Sepedi",
        "sr": "Serbe",
        "st": "Sesotho",
        "sn": "Shona",
        "sd": "Sindhî",
        "si": "Singhalais",
        "sk": "Slovaque",
        "sl": "Slovène",
        "so": "Somali",
        "es": "Spanish",
        "su": "Soundanais",
        "sw": "Swahili",
        "sv": "Suédois",
        "tl": "Tagalog",
        "tg": "Tadjik",
        "ta": "Tamoul",
        "tt": "Tatar",
        "te": "Télougou",
        "th": "Thaï",
        "ti": "Tigrinya",
        "ts": "Tsonga",
        "tr": "Turc",
        "tk": "Turkmène",
        "ak": "Twi",
        "uk": "Ukrainien",
        "ur": "Urdu",
        "ug": "Ouïghour",
        "uz": "Ouzbek",
        "vi": "Vietnamien",
        "cy": "Gallois",
        "xh": "Xhosa",
        "yi": "Yiddish",
        "yo": "Yoruba",
        "zu": "Zoulou"
    ]
