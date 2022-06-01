import 'package:flutter/material.dart';

class DesignBanner extends StatelessWidget {
  const DesignBanner({Key? key, required this.title, required this.subtitle}) : super(key: key);
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          constraints: const BoxConstraints(
            minHeight: 64,
            maxHeight: 100,
            minWidth: double.infinity,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.loose,
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/gradient.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Theme.of(context).colorScheme.secondary,
                      onTap: () {},
                      child: Center(
                        child: ListTile(
                          title: Text(
                            title,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          subtitle: Text(subtitle),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
