import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magic_slides_app/features/presentation/domain/entities/presentation_response.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/templates.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../data/models/presentation_request_model.dart';
import '../bloc/presentation_bloc.dart';
import '../bloc/presentation_event.dart';
import '../bloc/presentation_state.dart';
import 'result_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final _topicController = TextEditingController();
  final _extraInfoController = TextEditingController();

  String _templateType = 'Default';
  String _selectedTemplate = 'bullet-point1';
  int _slideCount = 10;
  String _language = 'en';
  bool _aiImages = false;
  bool _imageForEachSlide = true;
  bool _googleImage = false;
  bool _googleText = false;
  String _model = 'gpt-4';
  String _presentationFor = 'general audience';

  bool _showAdvanced = false;
  bool _isDarkMode = false;

  @override
  void dispose() {
    _topicController.dispose();
    _extraInfoController.dispose();
    super.dispose();
  }

  void _generatePresentation() {
    if (_formKey.currentState!.validate()) {
      final email = Supabase.instance.client.auth.currentUser?.email ?? '';

      final request = PresentationRequestModel(
        topic: _topicController.text.trim(),
        extraInfoSource: _extraInfoController.text.trim().isEmpty
            ? null
            : _extraInfoController.text.trim(),
        email: email,
        accessId: ApiConstants.accessId,
        template: _selectedTemplate,
        language: _language,
        slideCount: _slideCount,
        aiImages: _aiImages,
        imageForEachSlide: _imageForEachSlide,
        googleImage: _googleImage,
        googleText: _googleText,
        model: _model,
        presentationFor: _presentationFor,
      );

      context.read<PresentationBloc>().add(GeneratePresentationEvent(request));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(221, 19, 19, 19),
        foregroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.slideshow, color: Colors.white),
            const SizedBox(width: 8),
            const Text('MagicSlides'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
            },
          ),
          PopupMenuButton(
            offset: const Offset(-20, 40),
            color: Colors.white,
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Row(
                  children: [
                    Icon(Icons.logout, color: Colors.black),
                    SizedBox(width: 8),
                    Text('Logout', style: TextStyle(color: Colors.black)),
                  ],
                ),
                onTap: () {
                  Future.delayed(Duration.zero, () {
                    context.read<AuthBloc>().add(LogoutRequested());
                  });
                },
              ),
            ],
          ),
        ],
      ),
      body: BlocConsumer<PresentationBloc, PresentationState>(
        listener: (context, state) {
          if (state is PresentationSuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ResultPage(response: state.response),
              ),
            );
          } else if (state is PresentationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create Presentation',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _topicController,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'Topic',
                              hintText: 'Enter your presentation topic...',
                              prefixIcon: Icon(Icons.topic),
                            ),

                            validator: Validators.validateTopic,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _extraInfoController,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'Additional Information (Optional)',
                              hintText: 'Add extra context...',
                              prefixIcon: Icon(Icons.info_outline),
                            ),
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Template Selection',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          SegmentedButton<String>(
                            segments: const [
                              ButtonSegment(
                                value: 'Default',
                                label: Text('Default'),
                                icon: Icon(Icons.layers),
                              ),
                              ButtonSegment(
                                value: 'Editable',
                                label: Text('Editable'),
                                icon: Icon(Icons.edit),
                              ),
                            ],
                            selected: {_templateType},
                            onSelectionChanged: (Set<String> newSelection) {
                              setState(() {
                                _templateType = newSelection.first;
                                _selectedTemplate =
                                    Templates.templates[_templateType]![0];
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            dropdownColor: Colors.white,
                            focusColor: Colors.white,
                            value: _selectedTemplate,
                            decoration: const InputDecoration(
                              focusColor: Colors.white,
                              fillColor: Colors.white,
                              labelText: 'Choose Template',
                              prefixIcon: Icon(Icons.palette),
                            ),
                            items: Templates.templates[_templateType]!
                                .map(
                                  (template) => DropdownMenuItem(
                                    value: template,
                                    child: Text(template),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedTemplate = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Card(
                    elevation: 4,
                    child: Column(
                      children: [
                        ListTile(
                          title: Text('Advanced Settings'),
                          trailing: Icon(
                            _showAdvanced
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                          ),
                          onTap: () {
                            setState(() {
                              _showAdvanced = !_showAdvanced;
                            });
                          },
                        ),
                        if (_showAdvanced)
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Slide Count: $_slideCount',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 28),
                                Slider(
                                  thumbColor: Colors.white,
                                  value: _slideCount.toDouble(),
                                  min: 1,
                                  max: 50,
                                  divisions: 49,
                                  label: _slideCount.toString(),
                                  onChanged: (value) {
                                    setState(() {
                                      _slideCount = value.toInt();
                                    });
                                  },
                                ),
                                const SizedBox(height: 16),
                                DropdownButtonFormField<String>(
                                  dropdownColor: Colors.white,
                                  focusColor: Colors.white,
                                  value: _model,
                                  decoration: const InputDecoration(
                                    focusColor: Colors.white,
                                    fillColor: Colors.white,
                                    labelText: 'AI Model',
                                    prefixIcon: Icon(Icons.psychology),
                                  ),
                                  items: Templates.models
                                      .map(
                                        (model) => DropdownMenuItem(
                                          value: model,
                                          child: Text(model),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _model = value!;
                                    });
                                  },
                                ),
                                const SizedBox(height: 16),
                                DropdownButtonFormField<String>(
                                  dropdownColor: Colors.white,
                                  focusColor: Colors.white,
                                  value: _presentationFor,
                                  decoration: const InputDecoration(
                                    focusColor: Colors.white,
                                    fillColor: Colors.white,
                                    labelText: 'Audience',
                                    prefixIcon: Icon(Icons.people),
                                  ),
                                  items: Templates.presentationForOptions
                                      .map(
                                        (option) => DropdownMenuItem(
                                          value: option,
                                          child: Text(option),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _presentationFor = value!;
                                    });
                                  },
                                ),
                                const SizedBox(height: 16),
                                SwitchListTile(
                                  title: const Text('AI Generated Images'),
                                  value: _aiImages,
                                  onChanged: (value) {
                                    setState(() {
                                      _aiImages = value;
                                    });
                                  },
                                ),
                                SwitchListTile(
                                  title: const Text('Image on Each Slide'),
                                  value: _imageForEachSlide,
                                  onChanged: (value) {
                                    setState(() {
                                      _imageForEachSlide = value;
                                    });
                                  },
                                ),
                                SwitchListTile(
                                  title: const Text('Google Images'),
                                  value: _googleImage,
                                  onChanged: (value) {
                                    setState(() {
                                      _googleImage = value;
                                    });
                                  },
                                ),
                                SwitchListTile(
                                  title: const Text('Google Text'),
                                  value: _googleText,
                                  onChanged: (value) {
                                    setState(() {
                                      _googleText = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  CustomButton(
                    text: 'Generate Presentation',
                    // onPressed: _generatePresentation - uncomment this line to use actual generation
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ResultPage(
                          response: PresentationResponse(
                            success: true,
                            url:
                                // 'https://ide.mit.edu/wp-content/uploads/2023/03/0303PolicyForum_Ai_FF-2.pdf',
                                'https://www.slideserve.com/Tutors2/artificial-intelligence-ai-tools-in-scientific-research',
                            message: 'Success!',
                          ),
                        ),
                      ),
                    ),
                    isLoading: state is PresentationLoading,
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
