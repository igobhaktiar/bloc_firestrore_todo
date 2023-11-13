import '../model/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {
  final CollectionReference _todosCollectionReference =
      FirebaseFirestore.instance.collection('todos');

  Stream<List<Todo>> getTodos() {
    return _todosCollectionReference.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Todo(
          id: doc.id,
          title: data['title'],
          description: data['description'],
          completed: data['completed'],
        );
      }).toList();
    });
  }

  Future<void> addTodo(Todo todo) {
    return _todosCollectionReference.add({
      'title': todo.title,
      'description': todo.description,
      'completed': todo.completed,
    });
  }

  Future<void> updateTodo(Todo todo) {
    return _todosCollectionReference.doc(todo.id).update({
      'title': todo.title,
      'description': todo.description,
      'completed': todo.completed,
    });
  }

  Future<void> deleteTodoById(String id) {
    return _todosCollectionReference.doc(id).delete();
  }
}
