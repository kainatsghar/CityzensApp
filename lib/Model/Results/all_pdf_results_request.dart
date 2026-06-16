class AllPDFResultsRequest {
  final String studentId;
  final String tokenId;

  AllPDFResultsRequest({required this.studentId, required this.tokenId});

  Map<String, dynamic> toJson() {
    return {'id': studentId, 'tokenId': tokenId};
  }
}
