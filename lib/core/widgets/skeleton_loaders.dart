import 'package:flutter/material.dart';
import 'shimmer_loading.dart';

class PortfolioCardSkeleton extends StatelessWidget {
  const PortfolioCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonLine(width: 150, height: 20),
                      SizedBox(height: 8),
                      SkeletonLine(width: 100, height: 14),
                    ],
                  ),
                ),
                SkeletonBox(width: 24, height: 24, borderRadius: 12),
              ],
            ),
            const SizedBox(height: 16),

            const Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonLine(width: 80, height: 12),
                      SizedBox(height: 4),
                      SkeletonLine(width: 100, height: 16),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonLine(width: 80, height: 12),
                      SizedBox(height: 4),
                      SkeletonLine(width: 100, height: 16),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            SkeletonBox(height: 40, borderRadius: 8),
          ],
        ),
      ),
    );
  }
}

class AssetCardSkeleton extends StatelessWidget {
  const AssetCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: const Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            SkeletonAvatar(size: 40),
            SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonLine(width: 80, height: 16),
                  SizedBox(height: 4),
                  SkeletonLine(width: 120, height: 14),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SkeletonLine(width: 70, height: 16),
                SizedBox(height: 4),
                SkeletonLine(width: 50, height: 14),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PortfolioListSkeleton extends StatelessWidget {
  const PortfolioListSkeleton({super.key, this.itemCount = 3});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: PortfolioCardSkeleton(),
        ),
      ),
    );
  }
}

class AssetListSkeleton extends StatelessWidget {
  const AssetListSkeleton({super.key, this.itemCount = 5});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        itemBuilder: (context, index) => AssetCardSkeleton(),
      ),
    );
  }
}

class PortfolioDetailHeaderSkeleton extends StatelessWidget {
  const PortfolioDetailHeaderSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonLine(width: 200, height: 24),
            SizedBox(height: 8),
            SkeletonLine(width: 150, height: 16),
            SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    SkeletonLine(width: 80, height: 14),
                    SizedBox(height: 8),
                    SkeletonLine(width: 100, height: 20),
                  ],
                ),
                Column(
                  children: [
                    SkeletonLine(width: 80, height: 14),
                    SizedBox(height: 8),
                    SkeletonLine(width: 100, height: 20),
                  ],
                ),
                Column(
                  children: [
                    SkeletonLine(width: 80, height: 14),
                    SizedBox(height: 8),
                    SkeletonLine(width: 100, height: 20),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PortfolioSummarySkeleton extends StatelessWidget {
  const PortfolioSummarySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SkeletonBox(width: 48, height: 48, borderRadius: 12),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SkeletonLine(width: 100, height: 14),
                            SizedBox(height: 8),
                            SkeletonLine(width: 150, height: 24),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Divider(),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            SkeletonLine(width: 80, height: 14),
                            SizedBox(height: 8),
                            SkeletonLine(width: 100, height: 18),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            SkeletonLine(width: 80, height: 14),
                            SizedBox(height: 8),
                            SkeletonLine(width: 100, height: 18),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const SkeletonLine(width: 150, height: 20),
            const SizedBox(height: 12),

            PortfolioCardSkeleton(),
            const SizedBox(height: 12),
            PortfolioCardSkeleton(),
          ],
        ),
      ),
    );
  }
}
