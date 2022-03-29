import 'dart:convert';
import 'dart:io';

import 'package:gb_e_kyc/api/get.dart';
import 'package:gb_e_kyc/api/httpClient/pathUrl.dart';
import 'package:gb_e_kyc/api/post.dart';
import 'package:gb_e_kyc/bloc/addressBloc.dart';
import 'package:gb_e_kyc/getController/information_controller.dart';
import 'package:gb_e_kyc/model/personalInfoModel.dart';
import 'package:gb_e_kyc/utility/fileUitility.dart';
import 'package:gb_e_kyc/widgets/buttonConfirm.dart';
import 'package:gb_e_kyc/widgets/cameraScanIDCard.dart';
import 'package:gb_e_kyc/widgets/dialog/customDialog.dart';
import 'package:gb_e_kyc/widgets/dialog/deleteDialog.dart';
import 'package:gb_e_kyc/widgets/graySpace.dart';
import 'package:gb_e_kyc/widgets/selectAddress.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PersonalInfo extends StatefulWidget {
  final ocrAllFailed;
  final PersonalInfoModel? person;
  final Function? setIndex;
  final Function? setDataVisible;
  final Function? setScanIDVisible;
  final Function? setnextStepKYC;
  final Function? setFirstName;
  final Function? setLastName;
  final Function? setAddress;
  final Function? setAddressSearch;
  final Function? setBirthday;
  final Function? setIDCard;
  final Function? setLaserCode;
  final Function? setCareerID;
  final Function? setWorkName;
  final Function? setWorkAddress;
  final Function? setWorkAddressSearch;
  final Function? setindexProvince;
  final Function? setindexDistric;
  final Function? setindexSubDistric;
  final Function? setFileFrontCitizen;
  final Function? setFileBackCitizen;
  final Function? setFileSelfie;

  PersonalInfo({
    this.ocrAllFailed,
    this.person,
    this.setDataVisible,
    this.setScanIDVisible,
    this.setnextStepKYC,
    this.setIndex,
    this.setCareerID,
    this.setWorkAddress,
    this.setWorkName,
    this.setWorkAddressSearch,
    this.setindexProvince,
    this.setindexDistric,
    this.setindexSubDistric,
    this.setFileFrontCitizen,
    this.setFileBackCitizen,
    this.setFileSelfie,
    this.setFirstName,
    this.setLastName,
    this.setAddress,
    this.setAddressSearch,
    this.setBirthday,
    this.setIDCard,
    this.setLaserCode,
    Key? key,
  }) : super(key: key);

  int? getIndexSubDistric() {
    return _PersonalInfoState().indexSubDistrict;
  }

  int? getIndexDistric() {
    return _PersonalInfoState().indexDistrict;
  }

  int? getIndexProvince() {
    return _PersonalInfoState().indexProvince;
  }

  int? getCareerID() {
    return _PersonalInfoState().careerId;
  }

  String? getWorkname() {
    return _PersonalInfoState().workName;
  }

  String? getWorkAddress() {
    return _PersonalInfoState().workAddress;
  }

  String? getWorkAdressSearch() {
    return _PersonalInfoState().workAdressSearch;
  }

  @override
  _PersonalInfoState createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  String checkImage = "assets/images/Check.png";
  String unCheckImage = "assets/images/uncheck.png";
  String cameraImage = "assets/icons/camera.png";
  String? workName, workAddress, workAdressSearch;
  String? textBirthday;
  String? ocrResult;
  String? ocrResultStatus;
  String frontIDCardImage = "", backIDCardImage = "", selfieIDCard = "";
  String? fileFrontCitizen;
  String? fileBackCitizen;
  String? fileSelfie;

  int? indexCareer;
  int? indexCareerChild;
  int? careerId;
  int? careerChildId;

  int? indexProvince;
  int? indexDistrict;
  int? indexSubDistrict;

  bool checkValidate = false;
  bool? skipInfomation = false;
  bool validateCareer = false;
  bool validateCareerChild = false;

  GlobalKey<FormState> _formKey = GlobalKey();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final addressController = TextEditingController();
  final addressShowController = TextEditingController();
  final idCardController = TextEditingController();
  final laserCodeController = TextEditingController();
  final birthdayController = TextEditingController();
  final workNameController = TextEditingController();
  final workAddressController = TextEditingController();
  final workAddressShowController = TextEditingController();

  var address;

  MaskTextInputFormatter laserCodeFormatter = MaskTextInputFormatter(
    mask: '###-#######-##',
    filter: {"#": RegExp(r'[a-zA-Z0-9]')},
  );

  MaskTextInputFormatter idCardFormatter = MaskTextInputFormatter(
    mask: '#-####-#####-##-#',
    filter: {"#": RegExp(r'[0-9]')},
  );

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    onLoad();
    getAddress();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.clear();
    lastNameController.clear();
    addressController.clear();
    addressShowController.clear();
    birthdayController.clear();
    idCardController.clear();
    workNameController.clear();
    workAddressController.clear();
    workAddressShowController.clear();

    checkValidate = false;

    super.dispose();
  }

  getAddress() async {
    final response = await rootBundle.loadString('assets/thai-province-data.json');
    address = jsonDecode(response);

    List dataProvince = address['province'];
    List dataDistrict = address['district'];
    List dataSubDistrict = address['sub_district'];

    if (widget.person!.filterAddress!.isNotEmpty) {
      List filter = widget.person!.filterAddress!.split(' ');
      String filterProvince = filter[2];
      String filterDistrict = filter[1];
      String filterSubDistrict = filter[0];

      dataProvince.forEach((e) {
        if (RegExp(filterProvince.replaceAll('จ.', '')).hasMatch(e['name_th'])) {
          print(e);
          int provinceID = e['id'];
          String? province = e['name${'lang'.tr}'];
          dataDistrict.forEach((e) {
            if ((RegExp(filterDistrict.replaceAll('อ.', '')).hasMatch(e['name_th']) || RegExp(filterDistrict.replaceAll('เขต', '')).hasMatch(e['name_th'])) && e['province_id'] == provinceID) {
              print(e);
              int codeDistrict = e['code'];
              String? district = e['name${'lang'.tr}'];
              dataSubDistrict.forEach((e) {
                if (RegExp(filterSubDistrict).hasMatch(e['name_th']) && e['code'].toString().substring(0, 4) == codeDistrict.toString()) {
                  print(e);
                  widget.setindexProvince!(e['province_id']);
                  widget.setindexDistric!(e['district_id']);
                  widget.setindexSubDistric!(e['id']);
                  addressShowController.text = "$province/$district/${e['name${'lang'.tr}']}/${e['post_code']}";
                }
              });
            }
          });
        }
      });
    }
    dataProvince.sort((a, b) => a['name${'lang'.tr}'].compareTo(b['name${'lang'.tr}']));

    context.read<AddressBloc>().add(ClearProvince());
    for (var item in dataProvince) {
      context.read<AddressBloc>().add(SetProvince(item));
    }
  }

  onLoad() {
    idCardController.text = idCardFormatter.maskText(widget.person!.idCard ?? "");
    firstNameController.text = widget.person!.firstName ?? "";
    lastNameController.text = widget.person!.lastName ?? "";
    addressController.text = widget.person!.address ?? "";
    birthdayController.text = widget.person!.birthday ?? "";
    laserCodeController.text = laserCodeFormatter.maskText(widget.person!.ocrBackLaser ?? "");
    ocrResultStatus = widget.ocrAllFailed ? "Failed" : "Passed";
  }

  _selectDate(BuildContext context) async {
    showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
              height: 270,
              alignment: Alignment.center,
              color: Colors.white,
              child: Column(mainAxisSize: MainAxisSize.max, children: [
                ButtonConfirm(
                  text: 'ok'.tr,
                  radius: 0,
                  onPressed: () {
                    birthdayController.text = textBirthday!;
                    _formKey.currentState!.validate();
                    Navigator.of(context).pop();
                  },
                ),
                Container(
                  height: 220,
                  child: CupertinoDatePicker(
                    initialDateTime: DateTime.now(),
                    mode: CupertinoDatePickerMode.date,
                    minimumYear: 1900,
                    maximumYear: DateTime.now().year,
                    onDateTimeChanged: (v) {
                      textBirthday = DateFormat('dd/MM/yyyy').format(v);
                    },
                  ),
                ),
              ]),
            ));
  }

  Widget workLable() {
    return (!skipInfomation!)
        ? Column(children: [
            SizedBox(height: 20),
            TextFormField(
              controller: workNameController,
              style: TextStyle(fontSize: 15),
              validator: (v) {
                if (v!.isEmpty && checkValidate) return 'please_enter'.tr;
                return null;
              },
              onChanged: (v) {
                _formKey.currentState!.validate();
                widget.setWorkName!(v);
              },
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: 'careername'.tr),
            ),
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: TextFormField(
                        controller: workAddressShowController,
                        readOnly: true,
                        style: TextStyle(fontSize: 15),
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(labelText: "district_address".tr, hintText: "district_address".tr, suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black54)),
                        validator: (v) {
                          if (v!.isEmpty && checkValidate) {
                            return 'please_enter'.tr;
                          }
                          return null;
                        },
                        onChanged: (v) => _formKey.currentState!.validate(),
                        onTap: () => showModalSearchAddress('workAddress')))
              ],
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: workAddressController,
              style: TextStyle(fontSize: 15),
              validator: (v) {
                if (v!.isEmpty && checkValidate) return 'please_enter'.tr;
                return null;
              },
              onChanged: (v) {
                _formKey.currentState!.validate();
                widget.setWorkAddress!(v);
              },
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: 'addresscareer'.tr, hintText: 'house_number_floor_village_road'.tr),
            ),
          ])
        : SizedBox();
  }

  Widget dropdownCareer() {
    return FutureBuilder<Map>(
        future: GetAPI().call(url: '$hostRegister/careers', headers: Authorization.auth2),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!['success']) {
              final dataCareer = snapshot.data!['response']['data']['careers'];
              final data = dataCareer.map<DropdownMenuItem<int>>((item) {
                int index = dataCareer.indexOf(item);
                return DropdownMenuItem(
                  value: index + 1,
                  child: Text('${dataCareer[index]['name_${'language'.tr}']}'),
                );
              }).toList();
              return Stack(children: [
                Container(
                    height: 60,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    margin: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: validateCareer ? Colors.red : Color(0xFF02416D),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                            isDense: true,
                            isExpanded: true,
                            value: indexCareer,
                            hint: Text('- ${"career".tr} -'),
                            icon: Icon(Icons.keyboard_arrow_down_rounded),
                            style: TextStyle(color: Colors.black, fontFamily: 'kanit', fontSize: 15),
                            onChanged: (dynamic v) {
                              setState(() {
                                validateCareer = false;
                                validateCareerChild = false;
                                indexCareer = v;
                                indexCareerChild = null;
                                skipInfomation = dataCareer[v - 1]['skip_infomation'];
                                careerId = dataCareer[v - 1]['id'];
                                careerChildId = null;
                                // workNameController.clear();
                                // workAddressController.clear();
                                // workAddressShowController.clear();
                                widget.setCareerID!(v);
                              });
                            },
                            onTap: () {
                              widget.setCareerID!(indexCareer);
                            },
                            items: data))),
                indexCareer != null ? Positioned(top: 10, left: 10, child: Text(' ${"titlecareer".tr} ', style: TextStyle(fontSize: 12, color: Colors.black54, backgroundColor: Colors.white))) : SizedBox()
              ]);
            }
          }
          return SizedBox();
        });
  }

  Widget dropdownCareerChild() {
    return FutureBuilder<Map>(
      future: GetAPI().call(url: '$hostRegister/careers/$careerId/child', headers: Authorization.auth2),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!['success']) {
            final List dataCareerChild = snapshot.data!['response']['data']['careers'];
            if (dataCareerChild.isNotEmpty) {
              final data = dataCareerChild.map<DropdownMenuItem<int>>((item) {
                int index = dataCareerChild.indexOf(item);
                return DropdownMenuItem(
                  value: index + 1,
                  child: SizedBox(
                    width: 300,
                    child: Text(
                      '${dataCareerChild[index]['name_${'language'.tr}']}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              }).toList();
              return Stack(children: [
                Container(
                    height: 60,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    margin: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: validateCareerChild ? Colors.red : Color(0xFF02416D),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                            isDense: true,
                            isExpanded: true,
                            value: indexCareerChild,
                            hint: Text('- ${"career_more".tr} -'),
                            icon: Icon(Icons.keyboard_arrow_down_rounded),
                            style: TextStyle(color: Colors.black, fontFamily: 'kanit', fontSize: 15),
                            onChanged: (dynamic v) {
                              setState(() {
                                validateCareerChild = false;
                                indexCareerChild = v;
                                skipInfomation = dataCareerChild[v - 1]['skip_infomation'];
                                careerChildId = dataCareerChild[v - 1]['id'];
                                // workNameController.clear();
                                // workAddressController.clear();
                                // workAddressShowController.clear();
                              });
                            },
                            items: data))),
                indexCareerChild != null ? Positioned(top: 10, left: 10, child: Text(' ${"career_more_choice".tr} ', style: TextStyle(fontSize: 12, color: Colors.black54, backgroundColor: Colors.white))) : SizedBox()
              ]);
            }
            return SizedBox();
          }
        }
        return SizedBox();
      },
    );
  }

  void showModalSearchAddress(String from) {
    context.read<AddressBloc>().add(ClearDistrict());
    context.read<AddressBloc>().add(ClearSubDistrict());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
      builder: (context) => SelectAddress(address),
    ).then((v) {
      if (v != null) {
        _formKey.currentState!.validate();
        from == 'address'
            ? setState(() {
                addressShowController.text = v['showAddress'];
                widget.setindexProvince!(v['indexProvince']);
                widget.setindexDistric!(v['indexDistrict']);
                widget.setindexSubDistric!(v['indexSubDistrict']);
                widget.setAddressSearch!(v['showAddress']);
              })
            : setState(() {
                workAddressShowController.text = v['showAddress'];
                widget.setWorkAddressSearch!(v['showAddress']);
              });
      }
    });
  }

  Widget personInformation(double screenWidth) {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('idcard'.tr, style: TextStyle(fontSize: 24)), Text('${"Scan_result".tr} $ocrResultStatus', style: TextStyle(fontSize: 18))]),
          Text('about_profile'.tr, style: TextStyle(color: Colors.black54, fontSize: 16)),
          SizedBox(height: 20),
          Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Expanded(
                child: Container(
                    child: TextFormField(
                        controller: firstNameController,
                        style: TextStyle(fontSize: 15),
                        validator: (v) {
                          if (v!.isEmpty && checkValidate) {
                            return 'please_enter'.tr;
                          }
                          return null;
                        },
                        onChanged: (v) {
                          _formKey.currentState!.validate();
                          InformationController().setFirstName(v);
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(labelText: 'name'.tr)))),
            SizedBox(width: 20),
            Expanded(
                child: Container(
                    child: TextFormField(
                        controller: lastNameController,
                        style: TextStyle(fontSize: 15),
                        validator: (v) {
                          if (v!.isEmpty && checkValidate) {
                            return 'please_enter'.tr;
                          }
                          return null;
                        },
                        onChanged: (v) {
                          _formKey.currentState!.validate();
                          InformationController().setLastName(v);
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(labelText: 'nickname'.tr))))
          ]),
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  controller: addressShowController,
                  readOnly: true,
                  style: TextStyle(fontSize: 15),
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: "district_address".tr,
                    hintText: "district_address".tr,
                    suffixIcon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.black54,
                    ),
                  ),
                  validator: (v) {
                    if (v!.isEmpty && checkValidate) {
                      return 'please_enter'.tr;
                    }
                    return null;
                  },
                  onChanged: (v) => _formKey.currentState!.validate(),
                  onTap: () => showModalSearchAddress('address'),
                ),
              )
            ],
          ),
          SizedBox(height: 20),
          Row(children: [
            Expanded(
              child: Container(
                child: TextFormField(
                  controller: addressController,
                  style: TextStyle(fontSize: 15),
                  validator: (v) {
                    if (v!.isEmpty && checkValidate) {
                      return 'please_enter'.tr;
                    }
                    return null;
                  },
                  onChanged: (v) {
                    _formKey.currentState!.validate();
                    InformationController().setAddress(v);
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: 'address'.tr, hintText: 'house_number_floor_village_road'.tr),
                ),
              ),
            )
          ]),
          SizedBox(height: 20),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
            Expanded(
                child: TextFormField(
                    controller: birthdayController,
                    readOnly: true,
                    onTap: () => widget.ocrAllFailed ? _selectDate(context) : null,
                    style: TextStyle(fontSize: 15),
                    validator: (v) {
                      if (v!.isEmpty && checkValidate) return 'please_enter'.tr;
                      return null;
                    },
                    onChanged: (v) => _formKey.currentState!.validate(),
                    decoration: InputDecoration(fillColor: widget.ocrAllFailed ? Colors.white : Colors.grey[200], labelText: 'birthday'.tr, suffixIcon: Icon(Icons.calendar_today, color: Colors.black54)))),
            SizedBox(width: 20),
            Expanded(
              child: TextFormField(
                controller: idCardController,
                readOnly: !widget.ocrAllFailed,
                style: TextStyle(fontSize: 15),
                validator: (v) {
                  if (v!.isEmpty && checkValidate) return 'please_enter'.tr;
                  if (v.length != 17 && checkValidate) return "Please_enter_13_digit".tr;
                  return null;
                },
                onChanged: (v) => _formKey.currentState!.validate(),
                keyboardType: TextInputType.number,
                maxLength: 17,
                inputFormatters: [idCardFormatter],
                decoration: InputDecoration(
                  fillColor: widget.ocrAllFailed ? Colors.white : Colors.grey[200],
                  labelText: 'id_card_code'.tr,
                ),
              ),
            )
          ]),
          Container(
            padding: EdgeInsets.only(top: 10),
            width: screenWidth,
            margin: EdgeInsets.only(left: screenWidth * 0.475),
            child: TextFormField(
              controller: laserCodeController,
              readOnly: !widget.ocrAllFailed,
              style: TextStyle(fontSize: 15),
              validator: (v) {
                if (v!.isEmpty && checkValidate) return 'please_enter'.tr;
                return null;
              },
              onChanged: (v) => _formKey.currentState!.validate(),
              maxLength: 14,
              inputFormatters: [laserCodeFormatter],
              decoration: InputDecoration(fillColor: widget.ocrAllFailed ? Colors.white : Colors.grey[200], labelText: "id_card_laserNo".tr),
            ),
          )
        ]));
  }

  Widget idCardCapturing({double? screenWidth, double? screenheight}) {
    return Container(
      width: screenWidth,
      padding: EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("confirm_identity_image".tr, style: TextStyle(fontSize: 17)),
        Text("confirm_identity_image_description".tr, style: TextStyle(fontSize: 13, color: Color(0xff797979))),
        SizedBox(height: 20),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Image(
                image: AssetImage(frontIDCardImage.isEmpty ? unCheckImage : checkImage),
                width: 24,
              ),
              Text("idcard_front".tr, style: TextStyle(color: Color(0xff555555))),
              Text("photolight".tr + "/" + "photoandIDcard_info".tr, style: TextStyle(fontSize: 12, color: Color(0xff555555)))
            ]),
          ),
          SizedBox(width: 15),
          DottedBorder(
            dashPattern: [6, 3, 6, 3],
            padding: EdgeInsets.all(6),
            color: Color(0xffc4c4c4),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CameraScanIDCard(titleAppbar: 'Front_ID_Card'.tr, enableButton: true, isFront: true, noFrame: false)),
                  ).then((v) async {
                    if (v != null) {
                      int fileSize = await getFileSize(filepath: v);
                      if (frontIDCardImage.isNotEmpty) {
                        await File(frontIDCardImage).delete();
                      }
                      if (!isImage(v)) {
                        showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (context) {
                            return DeleteDialog(title: "Extension_not_correct".tr, textConfirm: "ok".tr, onPressedConfirm: () => Navigator.pop(context));
                          },
                        );
                      } else if (fileSize > 10000000) {
                        showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (context) {
                            return DeleteDialog(title: "File_size_larger".tr, textConfirm: "ok".tr, onPressedConfirm: () => Navigator.pop(context));
                          },
                        );
                      } else {
                        setState(() => frontIDCardImage = v);
                      }
                    }
                  });
                },
                child: Container(
                  height: 102,
                  width: 143,
                  child: frontIDCardImage.isEmpty ? Image.asset(cameraImage, scale: 3) : Image.file(File(frontIDCardImage), width: 143, fit: BoxFit.cover),
                ),
              ),
            ),
          )
        ]),
        Divider(height: 30, thickness: 2, color: Colors.grey[100]),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Image(image: AssetImage(backIDCardImage.isEmpty ? unCheckImage : checkImage), width: 24),
              Text("idcard_back".tr, style: TextStyle(color: Color(0xff555555))),
              Text("photolight".tr + "/" + "photoandIDcard_info".tr, style: TextStyle(fontSize: 12, color: Color(0xff555555))),
            ]),
          ),
          SizedBox(width: 15),
          DottedBorder(
            dashPattern: [6, 3, 6, 3],
            padding: EdgeInsets.all(6),
            color: Color(0xffc4c4c4),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CameraScanIDCard(titleAppbar: 'Back_ID_Card'.tr, enableButton: true, isFront: false, noFrame: false),
                    ),
                  ).then((v) async {
                    if (v != null) {
                      int fileSize = await getFileSize(filepath: v);
                      if (backIDCardImage.isNotEmpty) {
                        await File(backIDCardImage).delete();
                      }
                      if (!isImage(v)) {
                        showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (context) {
                            return DeleteDialog(title: "Extension_not_correct".tr, textConfirm: "ok".tr, onPressedConfirm: () => Navigator.pop(context));
                          },
                        );
                      } else if (fileSize > 10000000) {
                        showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (context) {
                            return DeleteDialog(title: "File_size_larger".tr, textConfirm: "ok".tr, onPressedConfirm: () => Navigator.pop(context));
                          },
                        );
                      } else {
                        setState(() => backIDCardImage = v);
                      }
                    }
                  });
                },
                child: Container(height: 102, width: 143, child: backIDCardImage.isEmpty ? Image.asset(cameraImage, scale: 3) : Image.file(File(backIDCardImage), width: 143, fit: BoxFit.cover)),
              ),
            ),
          )
        ]),
        Divider(height: 30, thickness: 2, color: Colors.grey[100]),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Image(image: AssetImage(selfieIDCard.isEmpty ? unCheckImage : checkImage), width: 24),
              Text("idcard_selfie".tr, style: TextStyle(color: Color(0xff555555))),
              Container(child: Text("photolight".tr + "/" + "photoandIDcard_info".tr, style: TextStyle(fontSize: 12, color: Color(0xff555555)))),
            ]),
          ),
          SizedBox(width: 15),
          DottedBorder(
            dashPattern: [6, 3, 6, 3],
            padding: EdgeInsets.all(6),
            color: Color(0xffc4c4c4),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CameraScanIDCard(titleAppbar: 'Selfie_ID_Card'.tr, enableButton: true, isFront: true, noFrame: true),
                    ),
                  ).then((v) async {
                    if (v != null) {
                      int fileSize = await getFileSize(filepath: v);
                      if (selfieIDCard.isNotEmpty) {
                        await File(selfieIDCard).delete();
                      }
                      if (!isImage(v)) {
                        showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (context) {
                            return DeleteDialog(title: "Extension_not_correct".tr, textConfirm: "ok".tr, onPressedConfirm: () => Navigator.pop(context));
                          },
                        );
                      } else if (fileSize > 10000000) {
                        showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (context) {
                            return DeleteDialog(title: "File_size_larger".tr, textConfirm: "ok".tr, onPressedConfirm: () => Navigator.pop(context));
                          },
                        );
                      } else {
                        setState(() => selfieIDCard = v);
                      }
                    }
                  });
                },
                child: Container(
                  height: 102,
                  width: 143,
                  child: selfieIDCard.isEmpty ? Image.asset(cameraImage, scale: 3) : Image.file(File(selfieIDCard), width: 143, fit: BoxFit.cover),
                ),
              ),
            ),
          )
        ])
      ]),
    );
  }

  Widget workInformation() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "titlecareer".tr,
          style: TextStyle(fontSize: 16),
        ),
        dropdownCareer(),
        if (careerId != null) dropdownCareerChild(),
        if (indexCareer != null) workLable(),
        SizedBox(height: 30),
        Row(children: [
          // Expanded(
          //   child: ButtonCancel(
          //       text: 'back'.tr,
          //       onPressed: () {
          //         Navigator.pushReplacement(
          //           context,
          //           MaterialPageRoute(
          //               builder: (BuildContext context) => Register()),
          //         );
          //       }),
          // ),
          // SizedBox(width: 20),
          Expanded(
            child: ButtonConfirm(
              text: 'continue'.tr,
              onPressed: () async {
                FocusScope.of(context).unfocus();
                checkValidate = true;
                if (careerId == null) {
                  setState(() => validateCareer = true);
                }
                if ((indexCareer == 19 || indexCareer == 20) && careerChildId == null) {
                  setState(() => validateCareerChild = true);
                }

                if (_formKey.currentState!.validate()) {
                  if (widget.ocrAllFailed && (frontIDCardImage.isEmpty || backIDCardImage.isEmpty || selfieIDCard.isEmpty)) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CustomDialog(
                          title: "confirm_identity_image".tr,
                          content: "confirm_identity_image_description".tr,
                          avatar: false,
                        );
                      },
                    );
                  } else if (careerId == null) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CustomDialog(
                          title: "career".tr,
                          content: "career_request".tr,
                          avatar: false,
                        );
                      },
                    );
                  } else if ((indexCareer == 19 || indexCareer == 20) && careerChildId == null) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CustomDialog(
                          title: "career_more".tr,
                          content: "career_request".tr,
                          avatar: false,
                        );
                      },
                    );
                  } else {
                    final res = await PostAPI().call(
                      url: '$hostRegister/users/pre_verify',
                      headers: Authorization.auth2,
                      body: {"id_card": idCardController.text.replaceAll('-', '')},
                    );

                    if (res['success']) {
                      if (careerChildId != null) {
                        careerId = careerChildId;
                        widget.setCareerID!(careerId);
                      }
                      if (frontIDCardImage.isNotEmpty) {
                        widget.setFileFrontCitizen!(frontIDCardImage);
                      }
                      if (backIDCardImage.isNotEmpty) {
                        widget.setFileBackCitizen!(backIDCardImage);
                      }
                      if (selfieIDCard.isNotEmpty) {
                        widget.setFileSelfie!(selfieIDCard);
                      }

                      widget.setFirstName!(firstNameController.text);
                      widget.setLastName!(lastNameController.text);
                      widget.setAddress!(addressController.text);
                      widget.setBirthday!(birthdayController.text);
                      widget.setIDCard!(idCardController.text.replaceAll('-', ''));
                      widget.setLaserCode!(laserCodeController.text.replaceAll('-', ''));

                      // widget.setDataVisible(false);
                      widget.setnextStepKYC!(true);
                      // widget.setIndex!(3);
                    }
                  }
                }
              },
            ),
          )
        ])
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;

    return ListView(physics: ClampingScrollPhysics(), padding: EdgeInsets.only(top: 5, bottom: 30), children: [
      Form(
          key: _formKey,
          child: Column(children: [
            personInformation(screenWidth),
            widget.ocrAllFailed ? GraySpace(boxHeight: 20) : Container(),
            widget.ocrAllFailed ? idCardCapturing(screenWidth: screenWidth, screenheight: screenheight) : Container(),
            GraySpace(boxHeight: 20),
            workInformation(),
          ]))
    ]);
  }
}
