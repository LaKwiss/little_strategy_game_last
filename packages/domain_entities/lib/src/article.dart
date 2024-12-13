import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Article extends Equatable {
  const Article({
    required this.title,
    required this.content,
    required this.author,
    this.imageUrl,
    this.publishedAt,
    this.subtitle,
  });

  final String title;
  final String content;
  final String author;
  final String? imageUrl;
  final DateTime? publishedAt;
  final String? subtitle;
  //TODO: Implement a category field

  @override
  List<Object?> get props => [title, content, author, imageUrl, publishedAt, subtitle];

  @override
  bool get stringify => true;

  Widget toWidget(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 635,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        imageUrl!,
                        width: 635,
                        height: 63,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const SizedBox.shrink(),
              Row(
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  Text(
                    'by $author',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  publishedAt != null
                      ? Text(
                          publishedAt!.toIso8601String(),
                          style: Theme.of(context).textTheme.headlineSmall,
                        )
                      : const SizedBox.shrink(),
                ],
              ),
              Row(
                children: [
                  subtitle != null
                      ? Text(
                          subtitle!,
                          style: Theme.of(context).textTheme.headlineSmall,
                        )
                      : const SizedBox.shrink(),
                  //TODO: Implement a category field
                ],
              ),
              Text(
                content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
