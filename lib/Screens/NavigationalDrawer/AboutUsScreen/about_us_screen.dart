import 'package:flutter/material.dart';
import 'package:tcs_app/CustomWidgets/CustomAppbar/custom_appbar.dart';

class AboutUsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AboutUsScreenState();
  }
}

class AboutUsScreenState extends State<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: 'About Us'),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ExpansionTile(
                title: Text('Overview',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic)),
                children: <Widget>[
                  Padding(
                    child: Text(
                      'The City School Overview\n\n' +
                          'Established in Karachi in 1978, The City School is today one of the largest private school networks in Pakistan with branches in all the major cities across the country. It currently has 166 schools in 49 cities with over 126,000 students in 458 owned and franchised schools. The City School continues to expand its reach to meet the demands for quality education. The knowledge and skills-based curriculum derived from the UK national curriculum guides students from Nursery to Cambridge International Examinations (for the 16 and 18 year age group), qualifying them for the IGCSE, and O and A Level examinations. The uniform implementation of the curriculum gives parents, students, and teachers the advantage of a smooth and efficient transfer from one school to another within the system.',
                      style: TextStyle(color: Colors.black),
                    ),
                    padding: EdgeInsets.all(10),
                  ),
                ],
              ),
              Divider(),
              ExpansionTile(
                title: Text(
                  "Group Chairperson's Message",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
                children: <Widget>[
                  Padding(
                      child: Text(
                          'Millennia ago, Socrates claimed that, “To say ‘I know’ is to close one’s mind to knowledge”. Channelling that spirit at The City School, our motto is ‘I Am To Learn’, because we too believe that learning is limitless. We aim to develop each one of our students into true learners, individuals who always seek to broaden their perspective and to face life’s challenges with courage and conviction.\n' +
                              '\n' +
                              'For us, education is a pursuit that goes far beyond a qualification. While we aim to help our students excel in the course they are studying, we also hope to instil in them a thirst for learning throughout their lives.  At The City School, our teachers, students, and parents work together to realise this goal.\n' +
                              '\n' +
                              'Group Chairperson',
                          style: TextStyle(color: Colors.black)),
                      padding: EdgeInsets.all(10)),
                ],
              ),
              Divider(),
              ExpansionTile(
                  title: Text(
                    'Mission Statement',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                  children: <Widget>[
                    Padding(
                        child: Row(children: <Widget>[
                          Expanded(
                              child: Text(
                                  '►  OUR PHILOSOPHY\n' +
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
                                      '    Professionalism',
                                  style: TextStyle(color: Colors.black)))
                        ]),
                        padding: EdgeInsets.all(10))
                  ]),
              Divider(),
              ExpansionTile(
                title: Text(
                  'Facilities',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
                children: <Widget>[
                  Padding(
                    child: Row(
                      children: <Widget>[
                        Text(
                          '►  Purpose-built Campuses\n\n' +
                              '►  Classrooms\n\n' +
                              '►  Laboratories\n\n' +
                              '►  Art\n\n' +
                              '►  Computer Labs\n\n' +
                              '►  Libraries\n\n' +
                              '►  Music\n\n',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(10),
                  ),
                ],
              ),
              Divider(),
            ],
          ),
        ));
  }
}
