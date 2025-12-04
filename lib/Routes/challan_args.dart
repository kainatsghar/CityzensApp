class ChallanArgs {
  const ChallanArgs({
    required this.studentId,
    required this.fatherCnic,
    required this.primaryContactNo,
    required this.isNewPaymentFlowEnabled,
  });

  final String studentId;
  final String fatherCnic;
  final String primaryContactNo;
  final bool isNewPaymentFlowEnabled;
}
