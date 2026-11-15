class CircleInvite {
  const CircleInvite({
    required this.id,
    required this.circleId,
    this.circleName = '',
    this.fromUid = '',
    this.fromName = '',
  });

  factory CircleInvite.fromMap(Map<String, dynamic> m, {required String id}) => CircleInvite(
        id: id,
        circleId: (m['circleId'] ?? '') as String,
        circleName: (m['circleName'] ?? '') as String,
        fromUid: (m['fromUid'] ?? '') as String,
        fromName: (m['fromName'] ?? '') as String,
      );

  final String id;
  final String circleId;
  final String circleName;
  final String fromUid;
  final String fromName;

  String get senderName => fromName.isEmpty ? 'Someone' : fromName;
  String get senderFirstName => senderName.split(' ').first;
  String get circleLabel => circleName.isEmpty ? 'a circle' : circleName;

  String get summary => '$senderFirstName invited you to $circleLabel';
}
