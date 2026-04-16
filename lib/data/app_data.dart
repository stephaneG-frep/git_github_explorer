import '../models/git_command.dart';
import '../models/lesson.dart';
import '../models/practice_item.dart';
import '../models/quiz_question.dart';
import '../models/visual_concept.dart';

const List<Lesson> lessons = [
  Lesson(
    id: 'git-basics',
    title: 'Git: les bases',
    summary: 'Comprendre ce qu est Git et pourquoi il est utile.',
    level: 'Debutant',
    tags: ['git', 'versionning'],
    content:
        'Git est un systeme de controle de version. Il enregistre les changements de ton projet dans le temps.\n\n'
        'Tu peux revenir en arriere, comparer des versions et travailler a plusieurs sans ecraser le travail des autres.',
  ),
  Lesson(
    id: 'github-basics',
    title: 'GitHub: le hub collaboratif',
    summary: 'Heberger tes depots Git et collaborer en equipe.',
    level: 'Debutant',
    tags: ['github', 'collaboration'],
    content:
        'GitHub est une plateforme en ligne qui heberge les depots Git.\n\n'
        'Tu peux partager ton code, ouvrir des Pull Requests, revoir du code et suivre les issues.',
  ),
  Lesson(
    id: 'git-vs-github',
    title: 'Difference Git / GitHub',
    summary: 'Ne plus confondre outil local et plateforme distante.',
    level: 'Debutant',
    tags: ['git', 'github'],
    content:
        'Git est un outil local installe sur ta machine. GitHub est un service en ligne qui utilise Git.\n\n'
        'En resume: Git gere l historique, GitHub facilite le partage et la collaboration.',
  ),
  Lesson(
    id: 'commit',
    title: 'Le commit',
    summary: 'Prendre une photo de ton travail avec un message clair.',
    level: 'Debutant',
    tags: ['commit', 'historique'],
    content:
        'Un commit enregistre un etat de ton code avec un message.\n\n'
        'Bon reflexe: des commits petits, frequents, et des messages explicites.',
  ),
  Lesson(
    id: 'branch-merge',
    title: 'Branch et merge',
    summary: 'Travailler en parallele puis fusionner proprement.',
    level: 'Intermediaire',
    tags: ['branch', 'merge'],
    content:
        'Une branch est une ligne de travail separee.\n\n'
        'Tu peux developper une fonctionnalite sans casser la branche principale. Ensuite, tu fusionnes via un merge.',
  ),
  Lesson(
    id: 'push-pull',
    title: 'Push et pull',
    summary: 'Synchroniser ton depot local avec le depot distant.',
    level: 'Debutant',
    tags: ['push', 'pull'],
    content:
        'git push envoie tes commits locaux vers GitHub.\n'
        'git pull recupere les nouveautes du depot distant.\n\n'
        'Le duo push/pull garde toute l equipe synchronisee.',
  ),
  Lesson(
    id: 'fork-pr',
    title: 'Fork et Pull Request',
    summary: 'Contribuer a un projet que tu ne possedes pas.',
    level: 'Intermediaire',
    tags: ['fork', 'pull request'],
    content:
        'Un fork est une copie d un depot dans ton compte GitHub.\n\n'
        'Tu fais tes modifications dans ton fork puis proposes une Pull Request pour integrer tes changements au projet original.',
  ),
  Lesson(
    id: 'clone',
    title: 'Clone: recuperer un depot',
    summary: 'Copier un depot distant en local pour commencer a travailler.',
    level: 'Debutant',
    tags: ['clone', 'depot'],
    content:
        'git clone <url> telecharge un depot GitHub sur ta machine.\n\n'
        'Tu obtiens tout l historique, les branches et les fichiers du projet pour travailler localement.',
  ),
  Lesson(
    id: 'remote-origin',
    title: 'Remote et origin',
    summary: 'Comprendre la connexion entre depot local et distant.',
    level: 'Debutant',
    tags: ['remote', 'origin'],
    content:
        'Un remote est un lien vers un depot distant (souvent GitHub).\n\n'
        '"origin" est le nom le plus courant du remote principal. Tu peux verifier avec git remote -v.',
  ),
  Lesson(
    id: 'gitignore',
    title: '.gitignore: quoi exclure',
    summary: 'Eviter de versionner les fichiers temporaires ou sensibles.',
    level: 'Debutant',
    tags: ['gitignore', 'bonnes pratiques'],
    content:
        'Le fichier .gitignore indique a Git quels fichiers ne pas suivre.\n\n'
        'Exemples: fichiers build, logs, secrets locaux, dossiers temporaires.',
  ),
  Lesson(
    id: 'rebase-basics',
    title: 'Rebase: historique plus lineaire',
    summary: 'Rejouer des commits sur une nouvelle base.',
    level: 'Intermediaire',
    tags: ['rebase', 'historique'],
    content:
        'git rebase deplace tes commits pour les rejouer sur une branche cible.\n\n'
        'Utilise-le avec prudence sur les branches partagees. Sur ta branche locale, il aide a garder un historique propre.',
  ),
  Lesson(
    id: 'stash',
    title: 'Stash: mettre de cote rapidement',
    summary: 'Sauvegarder provisoirement des changements non commits.',
    level: 'Intermediaire',
    tags: ['stash', 'workflow'],
    content:
        'git stash met tes modifications de cote temporairement.\n\n'
        'Pratique quand tu dois changer de branche vite sans perdre ton travail en cours.',
  ),
  Lesson(
    id: 'conflicts-resolution',
    title: 'Resoudre un conflit',
    summary: 'Lire, corriger et valider un conflit de merge proprement.',
    level: 'Intermediaire',
    tags: ['conflit', 'merge'],
    content:
        'Un conflit apparait quand deux changements touchent la meme zone.\n\n'
        'Tu choisis la bonne version (ou un mix), puis git add et commit pour finaliser la resolution.',
  ),
  Lesson(
    id: 'daily-workflow',
    title: 'Workflow quotidien Git',
    summary: 'Une routine simple pour travailler proprement en equipe.',
    level: 'Debutant',
    tags: ['workflow', 'equipe'],
    content:
        'Routine conseillee: pull -> branch -> petits commits -> push -> pull request.\n\n'
        'Ce flux reduit les conflits et rend le code review plus facile.',
  ),
];

const List<QuizQuestion> quizQuestions = [
  QuizQuestion(
    id: 'q1',
    question: 'A quoi sert principalement Git ?',
    options: [
      'A creer des interfaces graphiques',
      'A versionner le code et son historique',
      'A heberger des videos',
      'A compiler des applications mobiles',
    ],
    correctIndex: 1,
    explanation: 'Git sert a suivre les versions de ton code dans le temps.',
    difficulty: QuizDifficulty.easy,
    conceptKey: 'git-basics',
  ),
  QuizQuestion(
    id: 'q2',
    question: 'Quelle est la meilleure description de GitHub ?',
    options: [
      'Un editeur de texte',
      'Un langage de programmation',
      'Une plateforme de collaboration autour de depots Git',
      'Un antivirus',
    ],
    correctIndex: 2,
    explanation: 'GitHub heberge les depots Git et facilite la collaboration.',
    difficulty: QuizDifficulty.easy,
    conceptKey: 'github-basics',
  ),
  QuizQuestion(
    id: 'q3',
    question: 'Que fait un commit ?',
    options: [
      'Il supprime le projet',
      'Il sauvegarde un etat du code avec un message',
      'Il envoie du code en production',
      'Il cree un serveur',
    ],
    correctIndex: 1,
    explanation: 'Un commit est un point de sauvegarde de ton historique Git.',
    difficulty: QuizDifficulty.easy,
    conceptKey: 'commit',
  ),
  QuizQuestion(
    id: 'q4',
    question: 'Une branch sert a...',
    options: [
      'Travailler sur une piste separee',
      'Publier une app sur un store',
      'Supprimer les conflits',
      'Remplacer GitHub',
    ],
    correctIndex: 0,
    explanation: 'Une branche permet de travailler en parallele sans impacter main.',
    difficulty: QuizDifficulty.medium,
    conceptKey: 'branch-merge',
  ),
  QuizQuestion(
    id: 'q5',
    question: 'Une Pull Request est...',
    options: [
      'Un bug obligatoire',
      'Une demande de fusion de changements',
      'Un format d image',
      'Une commande Linux',
    ],
    correctIndex: 1,
    explanation: 'La Pull Request propose tes changements pour revue et fusion.',
    difficulty: QuizDifficulty.medium,
    conceptKey: 'fork-pr',
  ),
  QuizQuestion(
    id: 'q6',
    question: 'Quand utilises-tu en priorite git pull ?',
    options: [
      'Pour creer un nouveau depot',
      'Pour recuperer les changements distants',
      'Pour supprimer une branche locale',
      'Pour renommer un commit',
    ],
    correctIndex: 1,
    explanation: 'git pull recupere et integre les changements distants.',
    difficulty: QuizDifficulty.easy,
    conceptKey: 'push-pull',
  ),
  QuizQuestion(
    id: 'q7',
    question: 'Scenario ideal avant un merge complexe ?',
    options: [
      'Commit direct sur main sans verification',
      'Mettre a jour la branche et tester avant fusion',
      'Supprimer toutes les branches',
      'Ignorer les conflits',
    ],
    correctIndex: 1,
    explanation: 'Toujours synchroniser et tester avant de merger.',
    difficulty: QuizDifficulty.hard,
    conceptKey: 'branch-merge',
  ),
  QuizQuestion(
    id: 'q8',
    question: 'Un fork est surtout utile pour...',
    options: [
      'Contribuer a un depot que tu ne possedes pas',
      'Compiler plus vite',
      'Remplacer Git local',
      'Resoudre automatiquement les conflits',
    ],
    correctIndex: 0,
    explanation: 'Le fork te permet de proposer ensuite une Pull Request.',
    difficulty: QuizDifficulty.medium,
    conceptKey: 'fork-pr',
  ),
];

const List<PracticeItem> guidedExercises = [
  PracticeItem(
    id: 'e1',
    title: 'Premier commit',
    goal: 'Initialiser un depot et creer un premier commit.',
    steps: [
      'Creer un dossier de projet local.',
      'Executer git init.',
      'Creer un fichier README.md.',
      'Executer git add . puis git commit -m "first commit".',
    ],
  ),
  PracticeItem(
    id: 'e2',
    title: 'Travailler avec une branche',
    goal: 'Creer une branche, modifier puis fusionner.',
    steps: [
      'Executer git checkout -b feature/login.',
      'Modifier un fichier de ton projet.',
      'Commit tes changements.',
      'Revenir sur main et fusionner avec git merge feature/login.',
    ],
  ),
  PracticeItem(
    id: 'e3',
    title: 'Synchroniser avec GitHub',
    goal: 'Envoyer et recuperer des changements distants.',
    steps: [
      'Ajouter un remote avec git remote add origin <url>.',
      'Envoyer avec git push -u origin main.',
      'Recuperer les changements avec git pull origin main.',
    ],
  ),
];

const List<PracticeItem> simpleChallenges = [
  PracticeItem(
    id: 'c1',
    title: 'Defi: message de commit propre',
    goal: 'Ecrire un message de commit clair en une ligne.',
    steps: ['Exemple attendu: "feat: add login button validation".'],
  ),
  PracticeItem(
    id: 'c2',
    title: 'Defi: eviter le commit monstre',
    goal: 'Decouper une grosse modification en 3 commits logiques.',
    steps: ['Identifie 3 intentions differentes avant de commit.'],
  ),
  PracticeItem(
    id: 'c3',
    title: 'Defi: expliquer fork vs clone',
    goal: 'Formuler la difference en 2 phrases simples.',
    steps: ['Reponse concise et pedagogique.'],
  ),
];

const List<VisualConcept> visualConcepts = [
  VisualConcept(
    id: 'vc1',
    title: 'Historique des commits',
    description: 'Chaque commit est un point dans la timeline du projet.',
    nodes: ['Init', 'Config', 'Feature A', 'Fix bug'],
  ),
  VisualConcept(
    id: 'vc2',
    title: 'Arbre des branches',
    description: 'Les branches permettent des lignes de travail paralleles.',
    nodes: ['main', 'feature/auth', 'feature/ui'],
  ),
  VisualConcept(
    id: 'vc3',
    title: 'Merge',
    description: 'Fusionner une branche dans une autre.',
    nodes: ['main', 'feature/cart', 'merge commit'],
  ),
  VisualConcept(
    id: 'vc4',
    title: 'Conflits',
    description: 'Deux modifications incompatibles sur la meme zone.',
    nodes: ['Fichier A local', 'Fichier A distant', 'Resolution'],
  ),
  VisualConcept(
    id: 'vc5',
    title: 'Push / Pull',
    description: 'Sync locale <-> distante.',
    nodes: ['Local', 'git push', 'GitHub', 'git pull'],
  ),
  VisualConcept(
    id: 'vc6',
    title: 'Fork / Pull Request',
    description: 'Contribuer a un depot externe avec validation.',
    nodes: ['Repo original', 'Fork', 'Commits', 'Pull Request'],
  ),
];

const List<String> commandOfTheDay = [
  'git status',
  'git log --oneline --graph --decorate',
  'git checkout -b feature/new-screen',
  'git diff',
  'git stash',
  'git pull --rebase origin main',
];

const List<String> badgeNames = [
  'Commit Rookie',
  'Branch Explorer',
  'Merge Tamer',
  'Pull Request Hero',
  'GitHub Navigator',
];

const Map<String, String> conceptTips = {
  'git-basics': 'Astuce: pense a Git comme l historique de ton projet, localement.',
  'github-basics': 'Astuce: GitHub = partage et collaboration autour de depots Git.',
  'commit': 'Astuce: un commit = une intention claire avec un message explicite.',
  'branch-merge': 'Astuce: branche pour isoler, merge pour integrer apres verification.',
  'push-pull': 'Astuce: pull avant de travailler, push apres validation locale.',
  'fork-pr': 'Astuce: fork pour copier, Pull Request pour proposer tes changements.',
};

const List<GitCommand> gitCommands = [
  GitCommand(
    command: 'git init',
    category: 'Base',
    title: 'Initialiser un depot Git local',
    what: 'Cree un depot Git dans le dossier courant.',
    when: 'Quand tu commences un nouveau projet local.',
    example: 'git init',
    tip: 'Apres init, pense a faire un premier commit rapidement.',
  ),
  GitCommand(
    command: 'git status',
    category: 'Base',
    title: 'Voir l etat du projet',
    what: 'Affiche les fichiers modifies, indexes ou non suivis.',
    when: 'Tres souvent, avant et apres add/commit.',
    example: 'git status',
    tip: 'Prends l habitude de verifier status avant chaque commit.',
  ),
  GitCommand(
    command: 'git add <fichier> / git add .',
    category: 'Base',
    title: 'Preparer les fichiers pour commit',
    what: 'Place les changements dans la zone de staging.',
    when: 'Quand tu as decide ce que tu veux inclure dans le prochain commit.',
    example: 'git add .',
    tip: 'Prefere git add fichier_par_fichier pour des commits plus propres.',
  ),
  GitCommand(
    command: 'git commit -m "message"',
    category: 'Base',
    title: 'Enregistrer un point d historique',
    what: 'Cree un commit avec un message descriptif.',
    when: 'Quand une petite unite de travail est terminee.',
    example: 'git commit -m "feat: add login form"',
    tip: 'Un bon message explique l intention, pas juste le fichier modifie.',
  ),
  GitCommand(
    command: 'git log --oneline --graph --decorate',
    category: 'Historique',
    title: 'Lire l historique clairement',
    what: 'Montre les commits de facon compacte avec graphe.',
    when: 'Pour comprendre l ordre des commits et les branches.',
    example: 'git log --oneline --graph --decorate',
    tip: 'Ajoute --all pour voir toutes les branches.',
  ),
  GitCommand(
    command: 'git diff',
    category: 'Historique',
    title: 'Comparer les changements non indexes',
    what: 'Affiche les differences entre le fichier courant et le dernier commit.',
    when: 'Avant add/commit pour verifier ce que tu as modifie.',
    example: 'git diff',
    tip: 'Utilise git diff --staged pour ce qui est deja ajoute.',
  ),
  GitCommand(
    command: 'git branch',
    category: 'Branches',
    title: 'Lister les branches',
    what: 'Montre les branches locales et la branche active.',
    when: 'Pour savoir ou tu te trouves.',
    example: 'git branch',
    tip: 'La branche active est marquee par une etoile.',
  ),
  GitCommand(
    command: 'git checkout -b <nom> / git switch -c <nom>',
    category: 'Branches',
    title: 'Creer et changer de branche',
    what: 'Cree une nouvelle branche puis bascule dessus.',
    when: 'Au debut d une nouvelle fonctionnalite.',
    example: 'git switch -c feature/profile-page',
    tip: 'Nomme les branches selon l objectif: feature/, fix/, chore/.',
  ),
  GitCommand(
    command: 'git switch <nom>',
    category: 'Branches',
    title: 'Changer de branche',
    what: 'Bascule vers une branche existante.',
    when: 'Pour reprendre un autre travail.',
    example: 'git switch main',
    tip: 'Si Git refuse, commit ou stash d abord tes changements.',
  ),
  GitCommand(
    command: 'git merge <branche>',
    category: 'Fusion',
    title: 'Fusionner une branche',
    what: 'Integre les commits d une branche dans la branche courante.',
    when: 'Quand une fonctionnalite est validee.',
    example: 'git merge feature/profile-page',
    tip: 'Fais un pull sur main avant merge pour limiter les conflits.',
  ),
  GitCommand(
    command: 'git rebase <branche>',
    category: 'Fusion',
    title: 'Rejouer ses commits sur une autre base',
    what: 'Repositionne tes commits sur le haut d une autre branche.',
    when: 'Pour garder un historique lineaire sur des branches locales.',
    example: 'git rebase main',
    tip: 'Evite de rebase des commits deja partages en equipe.',
  ),
  GitCommand(
    command: 'git stash',
    category: 'Productivite',
    title: 'Mettre de cote les modifs en cours',
    what: 'Sauvegarde temporairement les changements non commits.',
    when: 'Quand tu dois changer de branche rapidement.',
    example: 'git stash',
    tip: 'Recupere ensuite avec git stash pop.',
  ),
  GitCommand(
    command: 'git stash pop',
    category: 'Productivite',
    title: 'Recuperer les modifs stashees',
    what: 'Reapplique le dernier stash et le supprime.',
    when: 'Quand tu reviens sur le contexte de travail.',
    example: 'git stash pop',
    tip: 'Si conflit, resols-le comme un merge classique.',
  ),
  GitCommand(
    command: 'git clone <url>',
    category: 'Remote',
    title: 'Copier un depot distant en local',
    what: 'Telecharge un depot GitHub complet sur ton poste.',
    when: 'Au debut d une contribution sur un projet existant.',
    example: 'git clone https://github.com/org/projet.git',
    tip: 'Clone dans un dossier propre pour eviter les confusions.',
  ),
  GitCommand(
    command: 'git remote -v',
    category: 'Remote',
    title: 'Verifier les depots distants',
    what: 'Affiche les URLs de pull/push configurees.',
    when: 'Quand push/pull ne va pas vers le bon depot.',
    example: 'git remote -v',
    tip: 'origin est le nom standard du remote principal.',
  ),
  GitCommand(
    command: 'git fetch',
    category: 'Remote',
    title: 'Recuperer sans fusionner',
    what: 'Telecharge les nouveautes distantes sans modifier ta branche.',
    when: 'Quand tu veux inspecter avant d integrer.',
    example: 'git fetch origin',
    tip: 'Ensuite compare avec git log ou git diff.',
  ),
  GitCommand(
    command: 'git pull',
    category: 'Remote',
    title: 'Recuperer et integrer',
    what: 'Fait fetch + merge (ou rebase selon config).',
    when: 'Avant de commencer ta journee sur une branche partagee.',
    example: 'git pull origin main',
    tip: 'Pull regulierement reduit les gros conflits tardifs.',
  ),
  GitCommand(
    command: 'git push',
    category: 'Remote',
    title: 'Envoyer ses commits',
    what: 'Publie tes commits locaux sur le depot distant.',
    when: 'Quand ton travail local est propre et teste.',
    example: 'git push -u origin feature/profile-page',
    tip: '-u lie la branche locale a la branche distante pour les prochains push.',
  ),
  GitCommand(
    command: 'git reset --soft HEAD~1',
    category: 'Correction',
    title: 'Annuler le dernier commit (garder les modifs)',
    what: 'Retire le commit mais laisse les changements en staging.',
    when: 'Si le message/decoupage du dernier commit est mauvais.',
    example: 'git reset --soft HEAD~1',
    tip: 'Utilise cette commande avec prudence sur des commits non pushes.',
  ),
  GitCommand(
    command: 'git revert <hash>',
    category: 'Correction',
    title: 'Annuler un commit proprement',
    what: 'Cree un nouveau commit qui annule un commit precedent.',
    when: 'Quand le commit est deja partage avec l equipe.',
    example: 'git revert a1b2c3d',
    tip: 'Revert est plus sur que reset sur une branche partagee.',
  ),
  GitCommand(
    command: 'git tag <nom>',
    category: 'Release',
    title: 'Marquer une version',
    what: 'Ajoute une etiquette sur un commit (ex: v1.0.0).',
    when: 'Au moment d une release stable.',
    example: 'git tag v1.0.0',
    tip: 'Pense a pousser les tags: git push --tags.',
  ),
  GitCommand(
    command: 'git rm --cached <fichier>',
    category: 'Correction',
    title: 'Retirer un fichier du suivi Git',
    what: 'Supprime un fichier de l index sans l effacer localement.',
    when: 'Quand un fichier sensible a ete ajoute par erreur.',
    example: 'git rm --cached .env',
    tip: 'Ajoute ensuite le fichier dans .gitignore.',
  ),
];
