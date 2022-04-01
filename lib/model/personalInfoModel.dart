class PersonalInfoModel {
  PersonalInfoModel({
    this.idCard,
    this.firstName,
    this.lastName,
    this.address,
    this.filterAddress,
    this.birthday,
    this.ocrBackLaser,
  });

  String? idCard, firstName, lastName, address, filterAddress, birthday, ocrBackLaser;

  @override
  String toString() {
    return 'PersonalInfoModel{idCard: $idCard, firstName: $firstName, lastName: $lastName, address: $address, filterAddress: $filterAddress, birthday: $birthday, ocrBackLaser: $ocrBackLaser}';
  }
}
