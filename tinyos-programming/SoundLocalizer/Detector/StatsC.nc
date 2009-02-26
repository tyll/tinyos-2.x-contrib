module StatsC {
  provides interface Stats;
}
implementation {
  /* A simple statistics package for computing least-squares linear
     regression of sample pairs. Equations from an HP11C calculator
     manual... */

  /* Store summaries of sample pairs X, Y:
     n: sample count
     sumX: sum of X samples,  sumY: sum of Y samples
     sumX2: sum of (X*X), sumY2: sum of (Y * Y),  sumXY: sum of (X*Y)
     n, sumX, sumY are kept as integers for performance and precision
     sumXY, sumX2, sumY2 are kept as floats to avoid overflow problems
  */
  uint32_t n, sumX, sumY;
  float sumXY, sumX2, sumY2;

  command void Stats.reset() {
    n = sumX = sumY = sumXY = sumX2 = sumY2 = 0;
  }

  command void Stats.data(uint32_t x, uint32_t y) {
    float fx = x, fy = y;

    n++;
    sumX += x;
    sumY += y;
    sumXY += fx * fy;
    sumX2 += fx * fx;
    sumY2 += fy * fy;
  }

  float M() {
    return n * sumX2 - (float)sumX * sumX;
  }

  float N() {
    return n * sumY2 - (float)sumY * sumY;
  }

  float P() {
    return n * sumXY - (float)sumX * sumY;
  }

  command float Stats.estimateY(uint32_t x) {
    float tm = M();

    return (tm * sumY + P() * (n * x - (float)sumX)) / (n * tm);
  }

  command float Stats.estimateX(uint32_t y) {
    float tn = N();

    return (tn * sumX + P() * (n * y - (float)sumY)) / (n * tn);
  }

  command uint32_t Stats.count() {
    return n;
  }
}
