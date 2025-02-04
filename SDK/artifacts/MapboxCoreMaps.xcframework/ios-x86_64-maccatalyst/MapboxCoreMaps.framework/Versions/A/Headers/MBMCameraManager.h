// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@class MBXExpected<__covariant Value, __covariant Error>;
@class MBXGeometry;
#import <MapboxCoreMaps/MBMStyleManager.h>

@class MBMCameraBounds;
@class MBMCameraBoundsOptions;
@class MBMCameraOptions;
@class MBMCameraState;
@class MBMCoordinateBounds;
@class MBMCoordinateBoundsZoom;
@class MBMCoordinateInfo;
@class MBMEdgeInsets;
@class MBMFreeCameraOptions;
@class MBMScreenBox;
@class MBMScreenCoordinate;

/** Interface for managing camera. */
NS_SWIFT_NAME(CameraManager)
__attribute__((visibility ("default")))
@interface MBMCameraManager : MBMStyleManager

/**
 * Convenience method that returns the `camera options` object for given parameters.
 *
 * @param bounds The `coordinate bounds` of the camera.
 * @param padding The `edge insets` of the camera.
 * @param bearing The bearing of the camera.
 * @param pitch The pitch of the camera.
 *
 * @return The `camera options` object representing the provided parameters.
 */
- (nonnull MBMCameraOptions *)cameraForCoordinateBoundsForBounds:(nonnull MBMCoordinateBounds *)bounds
                                                         padding:(nonnull MBMEdgeInsets *)padding
                                                         bearing:(nullable NSNumber *)bearing
                                                           pitch:(nullable NSNumber *)pitch __attribute((ns_returns_retained));
/**
 * Convenience method that returns the `camera options` object for given parameters.
 *
 * @param coordinates The `coordinates` representing the bounds of the camera.
 * @param padding The `edge insets` of the camera.
 * @param bearing The bearing of the camera.
 * @param pitch The pitch of the camera.
 *
 * @return The `camera options` object representing the provided parameters.
 */
- (nonnull MBMCameraOptions *)cameraForCoordinatesForCoordinates:(nonnull NSArray<CLLocation *> *)coordinates
                                                         padding:(nonnull MBMEdgeInsets *)padding
                                                         bearing:(nullable NSNumber *)bearing
                                                           pitch:(nullable NSNumber *)pitch __attribute((ns_returns_retained));
/**
 * Convenience method that adjusts the provided `camera options` object for given parameters.
 *
 * Returns the provided `camera` options with zoom adjusted to fit `coordinates` into the `box`, so that `coordinates` on the left,
 * top, right, and bottom of the effective `camera` center at the principal point of the projection (defined by `padding`) fit into the `box`.
 * Returns the provided `camera` options object unchanged upon an error.
 *
 * The method fails if the principal point is positioned outside of the `box`
 * or if there is no sufficient screen space, defined by principal point and the `box`, to fit the geometry.
 * Additionally, in cases when the principal point is positioned exactly on one of the edges of the `box`,
 * any geometry point that spans further than that edge on the same axis cannot possibly be framed and is ignored for zoom level calculation purposes.
 *
 * This API isn't supported by Globe projection.
 *
 * @param coordinates The `coordinates` representing the bounds of the camera.
 * @param camera The `camera options` for which zoom should be adjusted. Note that the `camera.center`, and `camera.zoom` (as fallback) is required.
 * @param box The `screen box` into which `coordinates` should fit.
 *
 * @return The `camera options` object with the zoom level adjusted to fit `coordinates` into the `box`.
 */
- (nonnull MBMCameraOptions *)cameraForCoordinatesForCoordinates:(nonnull NSArray<CLLocation *> *)coordinates
                                                          camera:(nonnull MBMCameraOptions *)camera
                                                             box:(nonnull MBMScreenBox *)box __attribute((ns_returns_retained));
/**
 * Convenience method that returns the `camera options` object for given parameters.
 *
 * @param geometry The `geometry` representing the bounds of the camera.
 * @param padding The `edge insets` of the camera.
 * @param bearing The bearing of the camera.
 * @param pitch The pitch of the camera.
 *
 * @return The `camera options` object representing the provided parameters.
 */
- (nonnull MBMCameraOptions *)cameraForGeometryForGeometry:(nonnull MBXGeometry *)geometry
                                                   padding:(nonnull MBMEdgeInsets *)padding
                                                   bearing:(nullable NSNumber *)bearing
                                                     pitch:(nullable NSNumber *)pitch __attribute((ns_returns_retained));
/**
 * Returns the `coordinate bounds` for a given camera.
 *
 * Note that if the given `camera` shows the antimeridian, the returned wrapped `coordinate bounds`
 * might not represent the minimum bounding box.
 *
 * @param camera The `camera options` to use for calculating `coordinate bounds`.
 *
 * @return The `coordinate bounds` object representing a given `camera`.
 *
 */
- (nonnull MBMCoordinateBounds *)coordinateBoundsForCameraForCamera:(nonnull MBMCameraOptions *)camera __attribute((ns_returns_retained));
/**
 * Returns the `coordinate bounds` for a given camera.
 *
 * This method is useful if the `camera` shows the antimeridian.
 *
 * @param camera The `camera options` to use for calculating `coordinate bounds`.
 *
 * @return The `coordinate bounds` object representing a given `camera`.
 *
 */
- (nonnull MBMCoordinateBounds *)coordinateBoundsForCameraUnwrappedForCamera:(nonnull MBMCameraOptions *)camera __attribute((ns_returns_retained));
/**
 * Returns the `coordinate bounds` and the `zoom` for a given `camera`.
 *
 * Note that if the given `camera` shows the antimeridian, the returned wrapped `coordinate bounds`
 * might not represent the minimum bounding box.
 *
 * @param camera The `camera options` to use for calculating `coordinate bounds` and `zoom`.
 *
 * @return The object representing `coordinate bounds` and `zoom` for a given `camera`.
 *
 */
- (nonnull MBMCoordinateBoundsZoom *)coordinateBoundsZoomForCameraForCamera:(nonnull MBMCameraOptions *)camera __attribute((ns_returns_retained));
/**
 * Returns the unwrapped `coordinate bounds` and `zoom` for a given `camera`.
 *
 * This method is useful if the `camera` shows the antimeridian.
 *
 * @param camera The `camera options` to use for calculating `coordinate bounds` and `zoom`.
 *
 * @return The object representing `coordinate bounds` and `zoom` for a given `camera`.
 *
 */
- (nonnull MBMCoordinateBoundsZoom *)coordinateBoundsZoomForCameraUnwrappedForCamera:(nonnull MBMCameraOptions *)camera __attribute((ns_returns_retained));
/**
 * Calculates a `screen coordinate` that corresponds to a geographical coordinate
 * (i.e., longitude-latitude pair).
 *
 * The `screen coordinate` is in `platform pixels` relative to the top left corner
 * of the map (not of the whole screen).
 *
 * @param coordinate A geographical `coordinate` on the map to convert to a `screen coordinate`.
 *
 * @return A `screen coordinate` on the screen in `platform pixels`.
 */
- (nonnull MBMScreenCoordinate *)pixelForCoordinateForCoordinate:(CLLocationCoordinate2D)coordinate __attribute((ns_returns_retained));
/**
 * Calculates a geographical `coordinate` (i.e., longitude-latitude pair) that corresponds
 * to a `screen coordinate`.
 *
 * The screen coordinate is in `platform pixels`relative to the top left corner
 * of the map (not of the whole screen).
 *
 * @param pixel A `screen coordinate` on the screen in `platform pixels`.
 *
 * @return A geographical `coordinate` corresponding to a given `screen coordinate`.
 */
- (CLLocationCoordinate2D)coordinateForPixelForPixel:(nonnull MBMScreenCoordinate *)pixel;
/**
 * Calculates the geographical coordinate information that corresponds to a given screen coordinate.
 *
 * The screen coordinate is in platform pixels, relative to the top left corner of the map (not the whole screen).
 *
 * The returned coordinate will be the closest position projected onto the map surface,
 * in case the screen coordinate does not intersect with the map surface.
 *
 * @param pixel The screen coordinate on the map, in platform pixels.
 *
 * @return A CoordinateInfo record containing information about the geographical coordinate corresponding to the given screen coordinate, including whether it is on the map surface.
 *
 */
- (nonnull MBMCoordinateInfo *)coordinateInfoForPixelForPixel:(nonnull MBMScreenCoordinate *)pixel __attribute((ns_returns_retained));
/**
 * Calculates `screen coordinates` that correspond to geographical `coordinates`
 * (i.e., longitude-latitude pairs).
 *
 * The `screen coordinates` are in `platform pixels` relative to the top left corner
 * of the map (not of the whole screen).
 *
 * @param coordinates A geographical `coordinates` on the map to convert to `screen coordinates`.
 *
 * @return A `screen coordinates` in `platform pixels` for a given geographical `coordinates`.
 */
- (nonnull NSArray<MBMScreenCoordinate *> *)pixelsForCoordinatesForCoordinates:(nonnull NSArray<CLLocation *> *)coordinates __attribute((ns_returns_retained));
/**
 * Calculates geographical `coordinates` (i.e., longitude-latitude pairs) that correspond
 * to `screen coordinates`.
 *
 * The screen coordinates are in `platform pixels` relative to the top left corner
 * of the map (not of the whole screen).
 *
 * @param pixels A `screen coordinates` in `platform pixels`.
 *
 * @return A `geographical coordinates` that correspond to a given `screen coordinates`.
 */
- (nonnull NSArray<CLLocation *> *)coordinatesForPixelsForPixels:(nonnull NSArray<MBMScreenCoordinate *> *)pixels __attribute((ns_returns_retained));
/**
 * Calculates the geographical coordinates information that corresponds to the given screen coordinates.
 *
 * The screen coordinates are in platform pixels, relative to the top left corner of the map (not the whole screen).
 *
 * The returned coordinate will be the closest position projected onto the map surface,
 * in case the screen coordinate does not intersect with the map surface.
 *
 * @param pixels The screen coordinate on the map, in platform pixels.
 *
 * @return The CoordinateInfo records containing information about the geographical coordinates corresponding to the given screen coordinates, including whether they are on the map surface.
 *
 */
- (nonnull NSArray<MBMCoordinateInfo *> *)coordinatesInfoForPixelsForPixels:(nonnull NSArray<MBMScreenCoordinate *> *)pixels __attribute((ns_returns_retained));
/**
 * Changes the map view by any combination of center, zoom, bearing, and pitch, without an animated transition.
 * The map will retain its current values for any details not passed via the camera options argument.
 * It is not guaranteed that the provided `camera options` will be set, the map may apply constraints resulting in a
 * different `camera state`.
 *
 * @param cameraOptions The new `camera options` to be set.
 */
- (void)setCameraForCameraOptions:(nonnull MBMCameraOptions *)cameraOptions;
/**
 * Returns the current `camera state`.
 *
 * @return The current `camera state`.
 */
- (nonnull MBMCameraState *)getCameraState __attribute((ns_returns_retained));
/**
 * Sets the map view with the free camera options.
 *
 * The `free camera options` provides more direct access to the underlying camera entity.
 * For backwards compatibility the state set using this API must be representable with
 * `camera options` as well. Parameters are clamped to a valid range or discarded as invalid
 * if the conversion to the pitch and bearing presentation is ambiguous. For example orientation
 * can be invalid if it leads to the camera being upside down or the quaternion has zero length.
 *
 * @param freeCameraOptions The `free camera options` to set.
 */
- (void)setCameraForFreeCameraOptions:(nonnull MBMFreeCameraOptions *)freeCameraOptions;
/**
 * Gets the map's current free camera options. After mutation, it should be set back to the map.
 *
 * @return The current `free camera options`.
 */
- (nonnull MBMFreeCameraOptions *)getFreeCameraOptions __attribute((ns_returns_retained));
/**
 * Returns the `camera bounds` of the map.
 * @return A `camera bounds` of the map.
 */
- (nonnull MBMCameraBounds *)getBounds __attribute((ns_returns_retained));
/**
 * Sets whether multiple copies of the world will be rendered side by side beyond -180 and 180 degrees longitude.
 * If disabled, when the map is zoomed out far enough that a single representation of the world does not fill the map's entire
 * container, there will be blank space beyond 180 and -180 degrees longitude.
 * In this case, features that cross 180 and -180 degrees longitude will be cut in two (with one portion on the right edge of the
 * map and the other on the left edge of the map) at every zoom level.
 * By default, By renderWorldCopies is set to `true`.
 *
 * @param renderWorldCopies The `boolean` value defining whether rendering world copies is going to be enabled or not.
 */
- (void)setRenderWorldCopiesForRenderWorldCopies:(BOOL)renderWorldCopies;
/**
 * Returns whether multiple copies of the world are being rendered side by side beyond -180 and 180 degrees longitude.
 * @return `true` if rendering world copies is enabled, `false` otherwise.
 */
- (BOOL)getRenderWorldCopies;
/**
 * Prepares the drag gesture to use the provided screen coordinate as a pivot `point`. This function should be called each time when user starts a dragging action (e.g. by clicking on the map). The following dragging will be relative to the pivot.
 *
 * @param point The pivot `screen coordinate`, measured in `platform pixels` from top to bottom and from left to right.
 */
- (void)dragStartForPoint:(nonnull MBMScreenCoordinate *)point;
/**
 * Calculates target point where camera should move after drag. The method should be called after `dragStart` and before `dragEnd`.
 *
 * @param fromPoint The `screen coordinate` to drag the map from, measured in `platform pixels` from top to bottom and from left to right.
 * @param toPoint The `screen coordinate` to drag the map to, measured in `platform pixels` from top to bottom and from left to right.
 *
 * @return The `camera options` object showing the end point.
 */
- (nonnull MBMCameraOptions *)getDragCameraOptionsForFromPoint:(nonnull MBMScreenCoordinate *)fromPoint
                                                       toPoint:(nonnull MBMScreenCoordinate *)toPoint __attribute((ns_returns_retained));
/** Ends the ongoing drag gesture. This function should be called always after the user has ended a drag gesture initiated by `dragStart`. */
- (void)dragEnd;

@end
