// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class CRUD {
//   final userId = FirebaseAuth.instance.currentUser?.uid;
//
//   Future<void> _saveQuizResult() async {
//     if (userId != null) {
//       // Fetch current progress data from Firestore
//       final docRef =
//           FirebaseFirestore.instance.collection('progress').doc(userId);
//       final docSnapshot = await docRef.get();
//
//       int quizzesTaken = 1;
//       double averageScore = score.toDouble();
//
//       if (docSnapshot.exists) {
//         final data = docSnapshot.data();
//         quizzesTaken = (data!['quizzesTaken'] as int) + 1;
//         averageScore =
//             ((data['averageScore'] as double) * (quizzesTaken - 1) + score) /
//                 quizzesTaken;
//       }
//
//       // Update Firestore with the new quiz result and updated progress
//       await docRef.set({
//         'quizzesTaken': quizzesTaken,
//         'averageScore': averageScore,
//       });
//
//       // Save this individual quiz result
//       await docRef.collection('quizResults').add({
//         'language': widget.language,
//         'difficulty': widget.difficulty,
//         'score': score,
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//     }
//   }
// }
