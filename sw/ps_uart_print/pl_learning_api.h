#ifndef PL_LEARNING_API_H
#define PL_LEARNING_API_H
/* Host/legacy builds retain the original C golden. Production PL-control ARM
 * builds have no software NMF/HDC arithmetic fallback. */
#if defined(PL_LEARNING_HOST_TEST) || (defined(__arm__) && defined(PL_CONTROL_ENABLE) && PL_CONTROL_ENABLE)
#define PL_LEARNING_ENABLE 1
static uint32_t pl_learning_nmf(const uint32_t e[8],uint32_t out[8]);
static uint32_t pl_learning_scale(const uint32_t *samples,uint32_t n,uint32_t scale[8]);
static uint32_t pl_learning_train(const uint32_t e[8],const uint32_t scale[8],int16_t *proto,uint32_t *saturated);
static uint32_t pl_learning_predict(const uint32_t e[8],const uint32_t scale[8],const int16_t *proto,uint32_t classes,
                                    uint32_t *best,uint32_t *margin,uint32_t *clip);
#else
#define PL_LEARNING_ENABLE 0
#endif
#endif
