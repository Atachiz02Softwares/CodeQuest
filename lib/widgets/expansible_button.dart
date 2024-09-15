import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utilities/colours.dart';
import 'widgets.dart';

class ExpansibleButton extends StatefulWidget {
  final String assetPath;
  final String buttonText;
  final List<String> difficulties;
  final Function(String) onDifficultySelected;
  final bool isExpanded;
  final VoidCallback onExpand;

  const ExpansibleButton({
    super.key,
    required this.assetPath,
    required this.buttonText,
    this.difficulties = const ['Beginner', 'Junior Developer', 'Professional'],
    required this.onDifficultySelected,
    required this.isExpanded,
    required this.onExpand,
  });

  @override
  State<ExpansibleButton> createState() => _ExpansibleButtonState();
}

class _ExpansibleButtonState extends State<ExpansibleButton> {
  String _selectedDifficulty = 'Beginner';

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return FrostedGlassContainer(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            InkWell(
              onTap: widget.onExpand,
              child: Row(
                children: [
                  SvgPicture.asset(
                    widget.assetPath,
                    width: screenSize.width * 0.1,
                    height: screenSize.width * 0.1,
                  ),
                  const SizedBox(width: 10),
                  CustomText(
                    text: widget.buttonText,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: widget.isExpanded ? 200 : 0,
              child: widget.isExpanded
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            child: ToggleButtons(
                              borderRadius: BorderRadius.circular(30),
                              fillColor: Colours.tertiary,
                              textStyle: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              selectedColor: Colours.primary,
                              isSelected: widget.difficulties
                                  .map((difficulty) =>
                                      difficulty == _selectedDifficulty)
                                  .toList(),
                              onPressed: (index) {
                                setState(() {
                                  _selectedDifficulty =
                                      widget.difficulties[index];
                                });
                              },
                              children: widget.difficulties.map((difficulty) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Text(difficulty),
                                );
                              }).toList(),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colours.tertiary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () {
                              widget.onDifficultySelected(_selectedDifficulty);
                            },
                            child: const CustomText(
                              text: 'Proceed',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
