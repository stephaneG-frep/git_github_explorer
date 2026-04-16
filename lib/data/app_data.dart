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
