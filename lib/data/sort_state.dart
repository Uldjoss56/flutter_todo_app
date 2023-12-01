class SortState {
  int? stateId;
  String stateName;

  SortState({
    this.stateId,
    required this.stateName,
  });

  Map<String, dynamic> toMap() {
    return {
      'stateName': stateName,
    };
  }

  static SortState fromMap(Map<String, dynamic> map) {
    return SortState(
      stateName: map['stateName'],
    );
  }
}
