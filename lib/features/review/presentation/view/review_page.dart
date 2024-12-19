import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:product_details/features/review/presentation/provider/review_provider.dart';
import 'package:provider/provider.dart';

class ReviewPage extends StatefulWidget {
  final String productId;
  const ReviewPage({super.key, required this.productId});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  @override
  void initState() {
    super.initState();
    final reviewProvider = Provider.of<ReviewProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      reviewProvider.fetchReviews(productId: widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final reviewProvider = Provider.of<ReviewProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Reviews'),
      ),
      body: Consumer<ReviewProvider>(
        builder: (context, review, child) {
          if (review.isFetching && review.reviewList.isEmpty) {
            return const LinearProgressIndicator();
          } else if (review.reviewList.isEmpty) {
            return const Center(
              child: Text('no reviews available'),
            );
          } else {
            return ListView.builder(
              itemCount: review.reviewList.length,
              itemBuilder: (context, index) {
                final reviews = review.reviewList[index];
                return Card(
                  child: Column(
                    children: [
                      Text(reviews.comment),
                      Text(reviews.rating.toString()),
                      TextButton(
                          onPressed: () {
                            reviewProvider.deleteReviews(
                                productId: widget.productId,
                                reviewId: reviews.id!);
                          },
                          child: const Text('delete'))
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Add yoer Reviews'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: reviewProvider.commentController,
                      decoration: InputDecoration(
                          hintText: 'Enter your review',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: reviewProvider.ratingController,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                          hintText: 'Enter Rating',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                    )
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('cancel')),
                  TextButton(
                      onPressed: () {
                        reviewProvider.addReviews(productId: widget.productId);
                        Navigator.pop(context);
                      },
                      child: const Text('Add')),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
