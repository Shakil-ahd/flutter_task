import 'package:flutter/material.dart';
import 'package:flutter_task/data/models/users_model.dart';

class UserDetailsDialog extends StatelessWidget {
  final UserModel user;

  const UserDetailsDialog({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 10,
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 70, 20, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                _buildDetailRow("Name", "${user.firstName} ${user.lastName}"),
                const Divider(),
                _buildDetailRow("Email", user.email),
                const Divider(),
                _buildDetailRow("Gender", user.gender.toUpperCase()),
                if (user.phone != null) ...[
                  const Divider(),
                  _buildDetailRow("Phone", user.phone!),
                ],
                if (user.city != null) ...[
                  const Divider(),
                  _buildDetailRow("City", user.city!),
                ],
                const SizedBox(height: 10),
              ],
            ),
          ),

          Positioned(
            top: -50,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 100,
                  width: 100,
                  color: Colors.white,
                  child: (user.image.isNotEmpty)
                      ? Image.network(user.image, fit: BoxFit.cover)
                      : const Icon(Icons.person, size: 50, color: Colors.grey),
                ),
              ),
            ),
          ),

          Positioned(
            top: 10,
            right: 10,
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.red, size: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              "$label :",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A00E0),
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
