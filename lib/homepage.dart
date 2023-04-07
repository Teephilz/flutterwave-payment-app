import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:flutterwave_payment_app/widget/textfielWidget.dart';
import 'package:flutterwave_standard/flutterwave.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController nameController= TextEditingController();
  TextEditingController phoneContoller= TextEditingController();
  TextEditingController emailController= TextEditingController();
  TextEditingController amountController= TextEditingController();
  GlobalKey<FormState>formKey=GlobalKey();
  GlobalKey<ScaffoldState>key=GlobalKey();

  String? ref;

  void setRef(){
    Random rand=Random();
    int number= rand.nextInt(2000);
    if(Platform.isAndroid){
      setState((){
        ref= "AndroidRef1234567899$number";
    });
    }
    else{
      setState((){
        ref= "IOSRef12345678$number";

      });
    }
  }

  @override
  void initState() {
     setRef();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: AppBar(
      title: Text("Flutter Wave Application"),
      ),
      body: Stack(
        children: [
          Padding(padding: EdgeInsets.all(8),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                CustomTextField(
                  controller: nameController,
                  validator: (value){
                    if(value.toString().isEmpty){
                      return 'kindly enter your name';
                    }
                  },
                  label: "Enter your name",
                  inputType: TextInputType.text,

                ),
                CustomTextField(
                  controller: emailController,
                  validator: (value){
                    if(value.toString().isEmpty){
                      return 'kindly enter your email';
                    }
                  },
                  label: "Enter your email",
                  inputType: TextInputType.emailAddress,

                ),

                CustomTextField(
                  controller: phoneContoller,
                  validator: (value){
                    if(value.toString().isEmpty){
                      return 'kindly enter your phone Number';
                    }
                  },
                  label: "Enter your Phone Number",
                  inputType: TextInputType.phone,

                ),

                CustomTextField(
                  controller: amountController,
                  validator: (value){
                    if(value.toString().isEmpty){
                      return 'kindly enter the amount';
                    }
                  },
                  label: "Enter your amount",
                  inputType: TextInputType.number,

                ),

                GestureDetector(
                  onTap: () async {
                    if(formKey.currentState!.validate()){
                      Customer customer= Customer(
                        email:emailController.text.trim(),
                        name: nameController.text.trim(),
                        phoneNumber: phoneContoller.text.trim(),);

                      final Flutterwave flutterwave = Flutterwave(
                          context: context ,
                          publicKey:"FLWPUBK_TEST-b960271255adc3154a835044f6b726a7-X",
                          currency: "NGN",
                          redirectUrl: "https://pub.dev/",
                          txRef: ref!,
                          amount: amountController.text.trim(),
                          customer: customer,
                          paymentOptions: "ussd, card, barter, payattitude",
                          customization: Customization(title: "Chat charges"),
                          isTestMode: false);
                      final ChargeResponse response = await flutterwave.charge();
                      if(response.status== "successful"){
                        FlutterToastr.show("Transaction Successful", context,
                            duration: FlutterToastr.lengthLong,
                            position: FlutterToastr.center,
                            backgroundColor: Colors.green);
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
                      }
                      else{
                        FlutterToastr.show("Transaction Successful", context,
                            duration: FlutterToastr.lengthLong,
                            position: FlutterToastr.center,
                            backgroundColor: Colors.red);
                      }
                    }
                    else{
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Fileds are empty")));
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width,
                    color: Colors.lightBlue,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.payment),
                        Text("Make Payment",
                          style: TextStyle(color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),),

        ],
      ),
    );
  }
}
