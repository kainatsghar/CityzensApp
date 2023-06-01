import 'package:flutter/material.dart';
import 'package:tcs_app/CustomWidgets/CustomAppbar/custom_appbar.dart';
import '../../../CustomWidgets/CustomExpansionTile/custom_expansion_tile.dart';
import '../../../CustomWidgets/CustomLogoCover/custom_logo_cover.dart';

class AboutUsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AboutUsScreenState();
  }
}

class AboutUsScreenState extends State<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: CustomAppBar(title: 'ABOUT US'),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: <Widget>[
                CustomLogoCover(),
                SizedBox(height: size.height * 0.03),
                CustomExpansionTile(
                    title: 'Overview',
                    detailMsg: 'The City School Overview\n\n' +
                        'Established in Karachi in 1978, The City School is today one of the largest private school networks in Pakistan with branches in all the major cities across the country. It currently has 166 schools in 49 cities with over 126,000 students in 458 owned and franchised schools. The City School continues to expand its reach to meet the demands for quality education. The knowledge and skills-based curriculum derived from the UK national curriculum guides students from Nursery to Cambridge International Examinations (for the 16 and 18 year age group), qualifying them for the IGCSE, and O and A Level examinations. The uniform implementation of the curriculum gives parents, students, and teachers the advantage of a smooth and efficient transfer from one school to another within the system.'),
                Divider(),
                CustomExpansionTile(
                    title: "Group Chairperson's Message",
                    detailMsg:
                        'Millennia ago, Socrates claimed that, “To say ‘I know’ is to close one’s mind to knowledge”. Channelling that spirit at The City School, our motto is ‘I Am To Learn’, because we too believe that learning is limitless. We aim to develop each one of our students into true learners, individuals who always seek to broaden their perspective and to face life’s challenges with courage and conviction.\n' +
                            '\n' +
                            'For us, education is a pursuit that goes far beyond a qualification. While we aim to help our students excel in the course they are studying, we also hope to instil in them a thirst for learning throughout their lives.  At The City School, our teachers, students, and parents work together to realise this goal.\n' +
                            '\n' +
                            'Group Chairperson'),
                Divider(),
                CustomExpansionTile(
                    title: "Mission Statement",
                    detailMsg: '►  OUR PHILOSOPHY\n' +
                        ''
                            '\n' +
                        '    Continuous Human Resource Development\n' +
                        '\n' +
                        '►  OUR GOAL\n' +
                        '\n' +
                        '    Academic Excellence\n' +
                        '\n' +
                        '►  OUR COMMITMENT\n' +
                        '\n' +
                        '    Total Satisfaction\n' +
                        '\n' +
                        '►  OUR CULTURE\n' +
                        '\n' +
                        '    Professionalism'),
                Divider(),
                CustomExpansionTile(
                    title: "Facilities",
                    detailMsg: '►  Purpose-built Campuses\n\n' +
                        '►  Classrooms\n\n' +
                        '►  Laboratories\n\n' +
                        '►  Art\n\n' +
                        '►  Computer Labs\n\n' +
                        '►  Libraries\n\n' +
                        '►  Music\n\n'),
              ],
            ),
          ),
        ));
  }
}
