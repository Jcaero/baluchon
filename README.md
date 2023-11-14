# Balluchon
projet 9 d'OC : création d'une Application de voyage

Le projet comprend 3 pages: 

- convertiseur de monnaie / Dollars
- traducteur de langue vers anglais
- météo

# ⚠️ Pour utiliser l'application 
Dans le Dossier Network, crée un fichier APIKey contenant vos clés privée

```swift
import Foundation
enum APIKey {
    case fixer
    case googleTranslate
    case openwheathermap

    var key: String {
        switch self {
        case .fixer:
            return "votre clé"
        case .googleTranslate:
            return "votre clé"
        case.openwheathermap:
            return "votre clé"
        }
    }
}
```

Lire la notice en PDF
