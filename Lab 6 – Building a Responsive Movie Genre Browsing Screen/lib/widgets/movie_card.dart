import 'package:flutter/material.dart';
import '../models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final bool isTabletLayout;

  const MovieCard({
    super.key,
    required this.movie,
    required this.isTabletLayout,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Build the star ratings list
    List<Widget> starRatingWidgets(double score) {
      double stars = score / 2.0; // convert 10-scale to 5-star scale
      List<Widget> list = [];
      int fullStars = stars.floor();
      bool hasHalfStar = (stars - fullStars) >= 0.25 && (stars - fullStars) < 0.75;
      if ((stars - fullStars) >= 0.75) fullStars++;

      for (int i = 1; i <= 5; i++) {
        if (i <= fullStars) {
          list.add(const Icon(Icons.star, color: Colors.amber, size: 14));
        } else if (i == fullStars + 1 && hasHalfStar) {
          list.add(const Icon(Icons.star_half, color: Colors.amber, size: 14));
        } else {
          list.add(const Icon(Icons.star_border, color: Colors.white24, size: 14));
        }
      }
      return list;
    }

    // Common info details
    Widget infoContent() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            movie.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${movie.year}',
                  style: const TextStyle(fontSize: 11, color: Colors.white70),
                ),
              ),
              const SizedBox(width: 8),
              ...starRatingWidgets(movie.rating),
              const SizedBox(width: 4),
              Text(
                '${movie.rating}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primaryContainer,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Genres wrapped in tags
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: movie.genres.map((g) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.2),
                  ),
                ),
                child: Text(
                  g,
                  style: TextStyle(
                    fontSize: 10,
                    color: theme.colorScheme.primaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      );
    }

    Widget posterImage(double width, double height) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: theme.colorScheme.surface,
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.network(
          movie.posterUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            // High quality fallback container if offline / blocked
            return Container(
              color: Colors.white10,
              alignment: Alignment.center,
              child: const Icon(
                Icons.movie_outlined,
                color: Colors.white30,
                size: 28,
              ),
            );
          },
        ),
      );
    }

    // Adaptive card structure based on layout
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: theme.colorScheme.surface.withOpacity(0.5),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // Show interactive SnackBar when a movie card is selected
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Selected: ${movie.title}'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        child: LayoutBuilder(
          builder: (context, cardConstraints) {
            if (isTabletLayout) {
              // Tablet/Grid layout: horizontal details beside poster inside a wider card
              double imageWidth = cardConstraints.maxWidth * 0.35;
              if (imageWidth < 100) imageWidth = 100;
              return Row(
                children: [
                  posterImage(imageWidth, double.infinity),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: infoContent(),
                    ),
                  ),
                ],
              );
            } else {
              // Phone layout: simple row layout with fixed width poster
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    posterImage(90, 120),
                    const SizedBox(width: 16),
                    Expanded(
                      child: infoContent(),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
