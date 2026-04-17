# Git & GitHub Explorer

Application Flutter pedagogique pour debutants afin d'apprendre Git et GitHub avec 3 modes:
- Apprendre
- Pratiquer
- Visualiser

## Stack
- Flutter + Material 3 (theme sombre)
- Donnees locales en Dart
- Persistance locale via `shared_preferences`

## Lancer le projet
```bash
flutter pub get
flutter run
```

## Qualite
```bash
flutter analyze
flutter test
```

## Fonctionnalites cle
- Parcours de lecons debutant -> intermediaire -> avance
- Quiz adaptatif avec difficulte
- Exercices guides + exercices par commande + defis
- Visualisations Git (branches, merge, conflits, push/pull, fork/PR)
- Commande du jour, badges, favoris, progression globale
- Export/import JSON de la progression (backup local)

## Preparation publication Android
Checklist minimale:
1. Verifier l'ID applicatif: `com.nabucode.gitgithubexplorer`
2. Verifier le label utilisateur: `Git & GitHub Explorer`
3. Remplacer l'icone launcher par l'icone finale
4. Configurer la signature release (keystore):
```bash
cp android/key.properties.example android/key.properties
# puis remplir android/key.properties avec tes vraies valeurs
```
5. Mettre a jour la version dans `pubspec.yaml`:
```yaml
version: 1.1.0+2
```
6. Generer un build release:
```bash
flutter build apk --release
# ou
flutter build appbundle --release
```
7. Tester sur appareil reel avant soumission

## Notes
- Le projet est optimise pour mobile et usage hors-ligne.
- Les donnees utilisateur restent locales tant qu'aucun backend n'est ajoute.
