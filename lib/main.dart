//import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:async' show Timer;
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Behaviour Change App',
      theme: ThemeData(
        //colorScheme: ColorScheme.fromSeed(
            //seedColor: Color.fromARGB(255, 7, 2, 16)),
            primarySwatch: Colors.blue,
            brightness: Brightness.dark,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Behaviour Change App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title, style: const TextStyle(color: Colors.black,)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                  return const SecondPage();
                }));
              },
              child: const Text('Click Here'),
            )
          ],
        ),
      ),
    );
  }
}

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20), // Adjust the top spacing
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Carousel with 3 images
                  CarouselSlider(
                    items: [
                      // Replace the AssetImage paths with your image assets
                      const AssetImage('images/image1.png'),
                      const AssetImage('images/image2.png'),
                      const AssetImage('images/image3.png'),
                    ].map((item) => Image(image: item)).toList(),
                    options: CarouselOptions(
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      enlargeCenterPage: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Text below images
                  const Text(
                    'Start working out to reach your creative peak.',
                    //style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Dots indicating the images
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < 3; i++)
                  Icon(
                    _currentIndex == i
                        ? Icons.circle
                        : Icons.circle_outlined,
                    size: 12,
                  ),
              ],
            ),
            const SizedBox(height: 20),
            // Button "Get Started"
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => const LoginPage(),
                ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 46, 196, 234),
                //backgroundColor: const Color.fromARGB(0, 0, 0, 0)
              ),
              child: const SizedBox(
                width: double.infinity, // Occupy the entire row
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 16),
                  child: Text(
                    'Get Started',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Text with link to terms of service and privacy policy
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20), 
              child:GestureDetector(
              onTap: () {
                // Add your onTap logic here
              },
              child: const Text(
                'By continuing you agree to the apps Terms of Service and Privacy Policy',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(255, 46, 196, 234),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Widgets for sign up options
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle sign up with Apple
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 46, 196, 234),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.apple,color:Colors.black), // Apple icon
                        SizedBox(width: 10),
                        Text(
                          'Sign up with Apple',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle sign up with Google
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 46, 196, 234),
                      minimumSize: const Size(double.infinity, 50),
                      alignment: Alignment.center,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.android,color:Colors.black), // G icon
                        SizedBox(width: 10),
                        Text(
                          'Sign up with Google',
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle sign up with Email
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 46, 196, 234),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.email,color: Colors.black,), // Email icon
                        SizedBox(width: 10),
                        Text(
                          'Sign up with Email',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Link to the login page
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const FourthPage(),
                  ));
                },
                child: const Text(
                  'Already have an account? Login',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 46, 196, 234),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class FourthPage extends StatelessWidget {
  const FourthPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Welcome back!',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Email Address',
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email address';
                }
                if (!isValidEmail(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Password',
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text(
                    'Forgot Password',
                    style: TextStyle(
                      color: Color.fromARGB(255, 46, 196, 234),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Validate the form before proceeding
                      if (Form.of(context).validate()) {
                        // Perform login logic here
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 46, 196, 234),
                    ),
                    child: const Text(
                      'Log in',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      child: const Text(
                        'Don\'t have an account? Sign up',
                        style: TextStyle(
                          color: Color.fromARGB(255, 33, 212, 243),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignupPage()));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isValidEmail(String email) {
    // Use a regular expression to validate email format
    return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(email);
  }
}


class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Let\'s get started!',
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Email Address',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Password (8+ characters)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          ),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 46, 196, 234),
                          ),
                          child: const Text('Create Account', style: TextStyle(color: Colors.black)),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      const Center(
                        child: Text('or'),
                      ),
                      const SizedBox(height: 10.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DemographicsPage())),
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 46, 196, 234)),
                          child: const Text('Continue with Apple', style: TextStyle(color: Colors.black))
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => {},
                          style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 46, 196, 234)),
                          child: const Text('Continue with Google', style: TextStyle(color: Colors.black) ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children:<Widget> [
                  TextButton(
                    child: const Text('Already have an account? Log in', style:TextStyle(color:Color.fromARGB(255, 33, 222, 243), decoration: TextDecoration.underline)),
                    onPressed: () => {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DemographicsPage())),
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DemographicsPage extends StatefulWidget {
  const DemographicsPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DemographicsPageState createState() => _DemographicsPageState();
}

class _DemographicsPageState extends State<DemographicsPage> {
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Demographics',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildGenderSelection(),
            const SizedBox(height: 20),
            _buildDateOfBirthSelection(),
            const SizedBox(height: 20),
            _buildRaceSelection(),
            const Spacer(),
            _buildNextButton(context),
            const SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select your gender',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedGender = 'Male';
                  });
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    selectedGender == 'Male' ? Colors.grey[800]! : Colors.grey[800]!

                  ),
                  side: MaterialStateProperty.all<BorderSide>(
                  BorderSide(
              color: selectedGender == 'Male' ? const Color.fromARGB(255, 118, 223, 232) : Colors.grey,
              width: 2.0, // Adjust the width of the border as needed
            ),
          ),
            
                ),
                child: Text(
                  'Male',
                  style: TextStyle(
                  color: selectedGender == 'Male' ? const Color.fromARGB(255, 91, 205, 236) : Colors.white,
  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedGender = 'Female';
                  });
                },
               style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                   selectedGender == 'Female' ? Colors.grey[800]! : Colors.grey[800]!,
                  ),
                  side: MaterialStateProperty.all<BorderSide>(
                  BorderSide(
              color: selectedGender == 'Female' ? const Color.fromARGB(255, 118, 223, 232) : Colors.grey,
              width: 2.0, // Adjust the width of the border as needed
            ),
          ),
                ),
                child: Text(
                  'Female',
                   style: TextStyle(
                   color: selectedGender == 'Female' ? const Color.fromARGB(255, 91, 205, 236) : Colors.white,)
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedGender = 'Other';
                  });
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    selectedGender == 'Other' ? Colors.grey[800]! : Colors.grey[800]!,
                  ),
                  side: MaterialStateProperty.all<BorderSide>(
                  BorderSide(
              color: selectedGender == 'Other' ? const Color.fromARGB(255, 118, 223, 232) : Colors.grey,
              width: 2.0, // Adjust the width of the border as needed
            ),
          ),
                ),
                child: Text(
                  'Other',
                  style: TextStyle(
                   color: selectedGender == 'Other' ? const Color.fromARGB(255, 91, 205, 236) : Colors.white,),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateOfBirthSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select your date of birth:',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 30),
        TextFormField(
          keyboardType: TextInputType.datetime,
          decoration: const InputDecoration(
            hintText: 'MM/DD/YYYY',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRaceSelection() {
    final List<String> raceOptions = ['Asian', 'Black', 'Hispanic', 'White', 'Other'];
    String? selectedRace;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Race:',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: selectedRace,
          onChanged: (newValue) {
            setState(() {
              selectedRace = newValue;
            });
          },
          items: raceOptions.map((race) {
            return DropdownMenuItem(
              value: race,
              child: Text(race),
            );
          }).toList(),
          decoration: const InputDecoration(
            hintText: 'Select race',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PhysicalCharacteristicsPage()));
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: const Color.fromARGB(255, 26, 219, 241), // Text color
        minimumSize: const Size(double.infinity, 50), // Full width button
      ),
      child: const Text('Next'),
    );
  }
}



class PhysicalCharacteristicsPage extends StatefulWidget {
  const PhysicalCharacteristicsPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PhysicalCharacteristicsPageState createState() =>
      _PhysicalCharacteristicsPageState();
}

class _PhysicalCharacteristicsPageState extends State<PhysicalCharacteristicsPage> {
  int selectedHeightFeet = 0;
  int selectedHeightInches = 0;
  String weightValue = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Physical Characteristics',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Select your height:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 150, // Fixed height for the dropdown
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: DropdownButton<int>(
                        value: selectedHeightFeet,
                        onChanged: (value) {
                          setState(() {
                            selectedHeightFeet = value!;
                          });
                        },
                        items: List.generate(
                          9,
                          (index) => DropdownMenuItem<int>(
                            value: index,
                            child: Text('$index ft'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20.0),
                Expanded(
                  child: SizedBox(
                    height: 150, // Fixed height for the dropdown
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: DropdownButton<int>(
                        value: selectedHeightInches,
                        onChanged: (value) {
                          setState(() {
                            selectedHeightInches = value!;
                          });
                        },
                        items: List.generate(
                          12,
                          (index) => DropdownMenuItem<int>(
                            value: index,
                            child: Text('$index inches'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Select your weight (lbs):',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            TextField(
              onChanged: (value) {
                setState(() {
                  weightValue = value;
                });
              },
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Enter weight',
                suffixText: 'lbs',
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle the next button action
                  // This is where you would navigate to the next page
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const  ComorbiditiesPage()));
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 55, 200, 226)),
                ),
                child: const Text('Next', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}

class ComorbiditiesPage extends StatefulWidget {
  const ComorbiditiesPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ComorbiditiesPageState createState() => _ComorbiditiesPageState();
}

class _ComorbiditiesPageState extends State<ComorbiditiesPage> {
  bool? hasHealthCondition;
  List<String> selectedHealthConditions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Comorbidities',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Do you have any health conditions?',
              style: TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 10.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: DropdownButton<String>(
                value: hasHealthCondition == null ? null : hasHealthCondition! ? 'Yes' : 'No',
                onChanged: (value) {
                  setState(() {
                    hasHealthCondition = value == 'Yes';
                  });
                },
                isExpanded: true,
                items: ['Yes', 'No']
                    .map((value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ))
                    .toList(),
                underline: Container(),
              ),
            ),
            const SizedBox(height: 20.0),
            if (hasHealthCondition == true) ...[
              const Text(
                'Select appropriate options:',
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 10.0),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Search health conditions',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                children: [
                  _buildHealthConditionButton('lorenipsum'),
                  _buildHealthConditionButton('ipsum'),
                  _buildHealthConditionButton('loren'),
                  _buildHealthConditionButton('ipsu'),
                  _buildHealthConditionButton('Lorenips'),
                ],
              ),
            ],
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle the next button action
                  // This is where you would navigate to the next page
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const GoalsPage()));
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 55, 200, 226)),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthConditionButton(String condition) {
  return ElevatedButton(
    onPressed: () {
      setState(() {
        toggleHealthCondition(condition);
      });
    },
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.black, backgroundColor: Colors.grey.shade800,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(9.0),
        side: BorderSide(color: selectedHealthConditions.contains(condition) ? const Color.fromARGB(255, 33, 233, 243) : Colors.transparent),
      ),
    ),
    child: Text(condition,style: TextStyle(
        color: selectedHealthConditions.contains(condition) ? Colors.cyan[200] : Colors.white,),)
  );
}


  void toggleHealthCondition(String condition) {
    if (selectedHealthConditions.contains(condition)) {
      selectedHealthConditions.remove(condition);
    } else {
      selectedHealthConditions.add(condition);
    }
  }
}


class GoalsPage extends StatefulWidget {
  const GoalsPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _GoalsPageState createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  bool isIntermediateSelected = false;
  bool isGradualSelected = false;
  String selectedFitnessLevel = '';
  String selectedProgram='';

void selectProgram(String program) {
  setState(() {
    selectedProgram = program;
  });
}
  List<String> selectedFitnessGoals = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [Expanded(
        child:SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Goals',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20.0),
          //const Padding(
            //padding: EdgeInsets.symmetric(horizontal: 20.0),
            const Text(
              'Fitness Level',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          //),
          const SizedBox(height: 10.0),
          Column(
            children: [
              _buildFitnessButton('Beginner', 'People who do not workout regularly'),
              const SizedBox(height: 10.0),
              _buildFitnessButton('Intermediate', 'People who have some experience in workouts'),
              const SizedBox(height: 10.0),
              _buildFitnessButton('Expert', 'People who are experienced and want to push limits'),
            ],
          ),
          const SizedBox(height: 20.0),
              const Text(
                'Fitness Goals',
                style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
          
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildFitnessGoalButton('Improves Strength'),
                        const SizedBox(height: 10.0),
                        _buildFitnessGoalButton('Increase Endurance'),
                        const SizedBox(height: 10.0),
                        _buildFitnessGoalButton('Gain muscle'),
                        const SizedBox(height: 10.0),
                        _buildFitnessGoalButton('Feel good'),
                        const SizedBox(height: 10.0),
                        _buildFitnessGoalButton('Recover from injury'),
                      ],
                    ),
              const SizedBox(height: 20.0),
              const Text(
                'Explore standard workout programs',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Choose a workout program from the options',
                style: TextStyle(fontSize: 12.0),
              ),
              const SizedBox(height: 10.0),
              ElevatedButton(
  onPressed: () {
    selectProgram('ACSM');
  },
  style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 39, 39, 40)),
    side: MaterialStateProperty.resolveWith<BorderSide>((states) {
      return selectedProgram == 'ACSM' ? const BorderSide(color: Colors.cyan, width: 2.0) : BorderSide.none;
    }),
  ),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'American College of Sports Medicine',
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color:Colors.white),
            ),
            Text(
              '150 minutes per week',
              style: TextStyle(fontSize: 10.0, color:Colors.white),
            ),
            Text(
              'Moderate to vigorous intensity',
              style: TextStyle(fontSize: 10.0, color:Colors.white),
            ),
            Text(
              'Atleast two days of strength training',
              style: TextStyle(fontSize: 10.0, color:Colors.white),
            ),
          ],
        ),
      ),
    SizedBox(
        width: 30, // Adjust the width as needed
        height: 30, // Adjust the height as needed
        child: Image.asset(
          'images/Americancollgeofmedicine.jpg', // Replace with your image asset path
          fit: BoxFit.cover, // Adjust the fit to cover or contain as needed
        ),
      ), 
    ],
  ),
),
const SizedBox(height: 15),
ElevatedButton(
  onPressed: () {
    selectProgram('AMA');
  },
  style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 49, 50, 51)),
    side: MaterialStateProperty.resolveWith<BorderSide>((states) {
      return selectedProgram=='AMA' ? const BorderSide(color: Colors.cyan, width: 2.0) : BorderSide.none;
    }),
  ),
  child:  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'American Heart Association',
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold,color:Colors.white),
            ),
            Text(
              '120 minutes per week',
              style: TextStyle(fontSize: 10.0,color:Colors.white),
            ),
            Text(
              'Easy to moderate intensity',
              style: TextStyle(fontSize: 10.0,color:Colors.white),
            ),
            Text(
              'Atleast 3 days of endurance training',
              style: TextStyle(fontSize: 10.0,color:Colors.white),
            ),
          ],
        ),
      ),
      SizedBox(
        width: 30, // Adjust the width as needed
        height: 30, // Adjust the height as needed
        child: Image.asset(
          'images/american_heart_association_logo.png', // Replace with your image asset path
          fit: BoxFit.cover,
        ),
      ), 
    ],
  ),
),

              const SizedBox(height: 20.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ExercisePage()));
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 55, 200, 226)),
                  ),
                  child: const Text('Next', style: TextStyle(color: Colors.black)),
                ),
              ),
            ],
          ),
        ),
      ),
      )
      ]
      )
    );
  }

  bool isGoalSelected(String goal) {
    return selectedFitnessGoals.contains(goal);
  }

  void toggleFitnessGoal(String goal) {
    if (selectedFitnessGoals.contains(goal)) {
      selectedFitnessGoals.remove(goal);
    } else {
      selectedFitnessGoals.add(goal);
    }
  }
Widget _buildFitnessButton(String title, String description) {
  bool isSelected = selectedFitnessLevel == title;

  return SizedBox(
    width: double.infinity,
    child: InkWell(
      onTap: () {
        setState(() {
          selectedFitnessLevel = title;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? Colors.cyan : Colors.transparent),
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16.0, color: isSelected ? Colors.cyan : null),
            ),
            const SizedBox(height: 5.0),
            Text(
              description,
              style: const TextStyle(fontSize: 12.0),
            ),
          ],
        ),
      ),
    ),
  );
}
Widget _buildFitnessGoalButton(String goal) {
  bool isSelected = isGoalSelected(goal);

  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () {
        setState(() {
          toggleFitnessGoal(goal);
        });
      },
      style: ButtonStyle(
       
        overlayColor: MaterialStateProperty.all<Color>(Colors.cyan.withOpacity(0.2) ),
        side: MaterialStateProperty.all<BorderSide>(BorderSide(color: isSelected ? Colors.cyan : Colors.transparent)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            goal,
            style: TextStyle(fontSize: 12.0, color: isSelected ? Colors.cyan : Colors.white),
          ),
          Theme(
            data: ThemeData(
              unselectedWidgetColor: Colors.grey, // Default color for unselected checkbox
            ),
            child: Checkbox(
              value: isSelected,
              onChanged: (value) {
                setState(() {
                  toggleFitnessGoal(goal);
                });
              },
              checkColor: isSelected ? Colors.cyan : Colors.grey, // Color of the checkmark
              activeColor: Colors.transparent, // Set active color to transparent to only show the checkmark
            ),
          ),
        ],
      ),
    ),
  );
}


}

class ExercisePage extends StatefulWidget {
  const ExercisePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  String selectedTrackingFrequency = '';
  List<String> selectedDays = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Exercise',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'How often do you track your fitness goals?',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 10.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
            child:DropdownButton<String>(
              value: selectedTrackingFrequency.isEmpty ? null : selectedTrackingFrequency,
              onChanged: (String? newValue) {
                setState(() {
                  selectedTrackingFrequency = newValue!;
                });
              },
              isExpanded: true,
              items: <String>['Daily', 'Weekly', 'Monthly']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              underline: Container(),
            ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Select your daily availability:',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (String day in ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'])
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        toggleDay(day);
                      });
                    },
                    style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.grey.shade800),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(
                      color:isDaySelected(day)? Colors.cyanAccent:Colors.grey.shade800, // Blue border color
                    ),
                    ),
                    ),
                  ),
                   child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(day,style: TextStyle(color:isDaySelected(day)?const Color.fromARGB(255, 101, 232, 237):Colors.white),), // Display day of the week
                      const Text('Select',style: TextStyle(color:Color.fromARGB(255, 73, 231, 234)),), // Display "Select" at the end of each button
                    ],
                  ),
                  ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const  PreferencesPage()));  
                },
                style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 55, 200, 226)),
                    ),
                child: const Text('Next',style: TextStyle(color: Colors.black),),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isDaySelected(String day) {
    return selectedDays.contains(day);
  }

  void toggleDay(String day) {
    if (selectedDays.contains(day)) {
      selectedDays.remove(day);
    } else {
      selectedDays.add(day);
    }
  }
}

class PreferencesPage extends StatefulWidget {
  const PreferencesPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PreferencesPageState createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  List<String> selectedExercises = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Preferences',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'What does your exercise routine include?',
              style: TextStyle(fontSize: 14.0),
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Enter your preference',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)), // Rounded border
                ),
                focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey), 
                      borderRadius: BorderRadius.all(Radius.circular(10.0)), // Set focused border color to transparent
                      ),
                      enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)), ),
                      
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Search exercises',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)), 
                        
                      ),
                      focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey), 
                      borderRadius: BorderRadius.all(Radius.circular(10.0)), // Set focused border color to transparent
                      ),
                      enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)), ),
                      prefixIcon: Icon(Icons.search), // Search icon
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Wrap(
              spacing: 10.0,
              children: [
                for (String exercise in [
                  'Pushups',
                  'Deadlifts',
                  'Lat Pulldown',
                  'Crunches',
                  'Mountain Climbers',
                  'Lunges',
                  'Bench Press',
                  'Jumping Jacks',
                  'Ball Squeeze',
                  'Reverse Plank'
                ])
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        toggleExercise(exercise);
                      });
                    },
                    style: ButtonStyle(
                      /*backgroundColor: MaterialStateProperty.all<Color>(
                        selectedExercises.contains(exercise)
                            ? Colors.green
                            : Colors.transparent,
                      ),*/
                      side: MaterialStateProperty.all<BorderSide>(
                        BorderSide(
                          color: selectedExercises.contains(exercise)
                              ?const Color.fromARGB(255, 50, 223, 236)
                              : Colors.grey,
                        ),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0), // Rounded button
                        ),
                      ),
                    ),
                    child: Text(exercise,style: TextStyle(
                    color: selectedExercises.contains(exercise) ? const Color.fromARGB(255, 50, 223, 236) : Colors.white,fontSize: 14,),
                  ),
                  ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle the next button action
                  // This is where you would navigate to the next page
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ExerciseLocationPage()));
                },
                style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 55, 200, 226)),
                    ),
                child: const Text('Next',style: TextStyle(color: Colors.black),),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void toggleExercise(String exercise) {
    if (selectedExercises.contains(exercise)) {
      selectedExercises.remove(exercise);
    } else {
      selectedExercises.add(exercise);
    }
  }
}

class ExerciseLocationPage extends StatefulWidget {
   const ExerciseLocationPage({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _ExerciseLocationPageState createState() => _ExerciseLocationPageState();
}

class _ExerciseLocationPageState extends State<ExerciseLocationPage> {
  List<String> selectedLocations = [];

  void toggleLocation(String location) {
    setState(() {
      if (selectedLocations.contains(location)) {
        selectedLocations.remove(location);
      } else {
        selectedLocations.add(location);
      }
    });
  }

  Widget buildLocationButton(String location) {
  final isSelected = selectedLocations.contains(location);
  return GestureDetector(
    onTap: () => toggleLocation(location),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        border: Border.all(
          color: isSelected ? const Color.fromARGB(255, 33, 219, 243) : Colors.grey,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            location,
            style: const TextStyle(
              fontSize: 14.0,
              color:Colors.white ,
            ),
          ),
          Container(
            width: 24.0,
            height: 24.0,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(4.0),
              border: Border.all(
                color:Colors.transparent,
                width: 1.0,
              ),
            ),
            child: isSelected
                ? const Icon(
                    Icons.check,
                    color: Color.fromARGB(255, 33, 208, 243),
                    size: 16.0,
                  )
                : null,
          ),
        ],
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Exercise Location',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40.0),
            const Text(
              'Where do you usually exercise?',
              style: TextStyle(fontSize: 14.0, color: Colors.white),
            ),
            const SizedBox(height: 20.0),
            buildLocationButton('Home'),
            buildLocationButton('YMCA'),
            buildLocationButton('PlanetFitness'),
           
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle the next button action
                      // This is where you would navigate to the next page
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ConnectWithFriendsPage()));
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 55, 200, 226)),
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConnectWithFriendsPage extends StatefulWidget {
  const ConnectWithFriendsPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ConnectWithFriendsPageState createState() => _ConnectWithFriendsPageState();
}

class _ConnectWithFriendsPageState extends State<ConnectWithFriendsPage> {
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
    
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Connect with your friends',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40.0),
            const Text(
              'Invite friends and compare your progress',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Enter email',
                      hintStyle: const TextStyle(color: Colors.white),
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(12.0)
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Send Invite',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      if (!value.contains('@') || !value.contains('.')) {
                        return 'Invalid email';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),

            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle the finish button action
                  // This is where you would navigate to the next page
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const WorkoutDurationSelectionPage()));

                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 33, 233, 243)),
                ),
                child: const Text('Finish',style: TextStyle(color: Colors.black),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WorkoutDurationSelectionPage extends StatelessWidget {
  const WorkoutDurationSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Workout Duration'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _startWorkout(context, const Duration(minutes: 15));
              },
              child: const Text('15 minutes'),
             
            ),
            ElevatedButton(
              onPressed: () {
                _startWorkout(context, const Duration(minutes: 30));
              },
              child: const Text('30 minutes'),
            ),
            // Add buttons for other workout durations as needed
          ],
        ),
      ),
    );
  }

  void _startWorkout(BuildContext context, Duration selectedDuration) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MondayBackWorkout15Minutes(pausedDuration: selectedDuration),
      ),
    );
  }
}

class MondayBackWorkout15Minutes extends StatelessWidget {
  final Duration pausedDuration;
  const MondayBackWorkout15Minutes({Key? key, required this.pausedDuration}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text('Back to workout', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10), // Adjust spacing as needed
            const Text('15 min workout', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 30), // Adjust spacing as needed
            Expanded(child: Align(alignment: Alignment.center,
            child: Padding(padding: const EdgeInsets.only(top: 50),
            child: ElevatedButton(
              onPressed: () 
              { Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  PauseStopPage(pausedDuration: pausedDuration))); },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,padding: const EdgeInsets.all(50), backgroundColor: Colors.white, shape: const CircleBorder(), // Text color
        elevation: 10,
              ),
              child:const Text('Start'),
              
            ),
            )
            )
            )
          ],
        ),
      ),
    );
  }
}

class PauseStopPage extends StatefulWidget {
  final Duration pausedDuration;

  const PauseStopPage({Key? key, required this.pausedDuration}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PauseStopPageState createState() => _PauseStopPageState();
}

class _PauseStopPageState extends State<PauseStopPage> {
  late Duration duration;
  late Timer timer;
  bool isPaused = false;
  @override
  void initState(){
    super.initState();
    duration = Duration.zero;
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        duration += const Duration(seconds: 1);
      });
    });
  }
  void handlePause() {
    if (!isPaused) {
      timer.cancel();
      setState(() {
        isPaused = true; // Set timer state to paused
      });
    
    } else {
      startTimer();
      setState(() {
        isPaused = false; // Set timer state to running
      });
    }
  }

  void handleStop() {
    // Logic to handle stopping and recording final time (implementation may vary)
    timer.cancel();
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WorkoutCompletionPage(stoppedDuration: duration, selectedDuration: widget.pausedDuration),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 100),
            Text(
              StopwatchDisplay.displayTime(duration),
              style: const TextStyle(fontSize: 100,color: Colors.cyan),
            ),
            const SizedBox(height: 150),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: IconButton(
                  onPressed: handlePause,
                  icon:Icon(isPaused ? Icons.play_arrow : Icons.pause),
                  iconSize: 40,
                  color: Colors.black,
                ),
                 ),
                const SizedBox(width: 40),
                Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: IconButton(
                  onPressed: handleStop,
                  icon: const Icon(Icons.stop),
                  iconSize: 40,
                  color: Colors.black,
                //  child: const Text('Stop'),
                ),
                ),
              ],
            ),
          ],
        ),
     );
    //);
  }
}

class StopwatchDisplay {
  static String displayTime(Duration duration) {
    String minutes = (duration.inMinutes % 60).toString().padLeft(2, "0");
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, "0");
    return '$minutes:$seconds';
  }
}

class WorkoutCompletionPage extends StatelessWidget {
  final Duration stoppedDuration;
  final Duration selectedDuration;

  const WorkoutCompletionPage({
    Key? key,
    required this.stoppedDuration,
    required this.selectedDuration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool completed = stoppedDuration >= selectedDuration;
    bool endedEarly = stoppedDuration < selectedDuration;

    // Calculate success rate percentage
    double successRate = endedEarly ? (stoppedDuration.inSeconds / selectedDuration.inSeconds) * 100 : 100.0;
    if (endedEarly) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return  ModalScreen(stoppedDuration: stoppedDuration, selectedDuration: selectedDuration,);
          },
        );
      });
    }

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Today - [Current Time]
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Today - ${DateFormat('MMM dd, yyyy').format(DateTime.now())}', style: const TextStyle(color: Colors.white)),
                //Text('Time: ${DateFormat('hh:mm a').format(DateTime.now())}'),
              ],
            ),
            const SizedBox(height: 10),
            // Workout Text
            const Text('Today Workout', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 10),
            // Stopped Time and Points
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(StopwatchDisplay.displayTime(stoppedDuration), style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 5),
                    const Text('Time', style: TextStyle(color: Colors.white)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('100', style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: endedEarly? Colors.red: Colors.blue)),
                        Icon(
                          completed ? Icons.arrow_upward : Icons.arrow_downward,
                          color: endedEarly ? Colors.red : Colors.blue,
                          size: 50,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Text('Points', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Time Text
            //Text('Time: ${DateFormat('hh:mm a').format(DateTime.now())}'),
            const SizedBox(height: 10),
            // Points Text
            //const Text('100'),
            const SizedBox(height: 20),
            // Selected Time, Goal, and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      StopwatchDisplay.displayTime(selectedDuration),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 5),
                    const Text('Goal', style: TextStyle(color: Colors.white)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      endedEarly ? 'Ended Early' : 'Workout Completed',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 5),
                    const Text('Status', style: TextStyle(color: Colors.white)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${successRate.toStringAsFixed(2)}%',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 5),
                    const Text('Success Rate %', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class ModalScreen extends StatefulWidget {
  final Duration stoppedDuration;
  final Duration selectedDuration;

  const ModalScreen({
    Key? key,
    required this.stoppedDuration,
    required this.selectedDuration,
  }) : super(key: key);


  @override
  // ignore: library_private_types_in_public_api
  _ModalScreenState createState() => _ModalScreenState();
}

class _ModalScreenState extends State<ModalScreen> {
  List<String> selectedOptions = [];
  bool showMoreOptions = false;
  bool thumbsUpSelected = false;
  bool thumbsDownSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Workout Ended Early', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              const Text('We see that the workout has ended early. How did you do?'),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        thumbsUpSelected = !thumbsUpSelected;
                        thumbsDownSelected = false;
                        showMoreOptions = thumbsUpSelected;
                      });
                    },
                    icon: const Icon(Icons.thumb_up),
                    iconSize: 40,
                    color: thumbsUpSelected ? Colors.cyan : Colors.grey,
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        thumbsDownSelected = !thumbsDownSelected;
                        thumbsUpSelected = false;
                        showMoreOptions = thumbsDownSelected;
                      });
                    },
                    icon: const Icon(Icons.thumb_down),
                    iconSize: 40,
                    color: thumbsDownSelected ? Colors.cyan : Colors.grey,
                  ),
                ],
              ),
              if (showMoreOptions) ...[
                const SizedBox(height: 20),
                const Text('Tell us more'),
                const SizedBox(height: 10),
                // Display additional options
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOptionsWrap([
                            'Tired',
                            'Equipment Issue',
                            'Injured',
                            'Equipment Not Found',
                          ])
                  ]
                  

                ),
              
              const SizedBox(height: 20),
              Row(
              children:[
                Expanded(
                child:ElevatedButton(
                
                onPressed: () {
                  // Perform submit action
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
               ),
                child: const Text('Submit',style: TextStyle(color:Colors.black),),
              ),
              ),
              ],
              ),
            ],
            ],
          ),
        ),
      ),
    );
  }
Widget _buildOption(String option) {
  bool isSelected = selectedOptions.contains(option);

  return Padding(
    padding: const EdgeInsets.only(right: 8.0),
    child: ElevatedButton(
      onPressed: () {
        setState(() {
          if (isSelected) {
            selectedOptions.remove(option);
          } else {
            selectedOptions.add(option);
          }
        });
      },
      style: ButtonStyle(
        side: MaterialStateProperty.resolveWith<BorderSide>((states) {
          return isSelected ? const BorderSide(color: Colors.cyan, width: 2.0) : BorderSide.none;
        }),
        
      ),
      child: Text(option, style: TextStyle(color: isSelected ? Colors.cyan : Colors.white)),
    ),
  );
}

Widget _buildOptionsWrap(List<String> options) {
  return Wrap(
    spacing: 8.0, // Spacing between the children
    runSpacing: 8.0, // Spacing between the rows
    children: options.map((option) => _buildOption(option)).toList(),
    alignment: WrapAlignment.start, // Align children to the start of each line
    crossAxisAlignment: WrapCrossAlignment.start, // Align children's baselines to the start of each line
  );
}
}

  