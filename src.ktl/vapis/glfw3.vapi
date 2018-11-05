/**
 * glfw3 Vala Bindings
 * MIT License
 * Copyright (c) 2018 Bruce Davidson <darkoverlordofdata@gmail.com>
 * 
 *------------------------------------------------------------------------
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * 'Software'), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *------------------------------------------------------------------------
 * 
 * Straight from GLFW/glfw3.h:
 *
 * vala bindinds sans the oop syntactic sugar. For published api's like glfw,
 * this is really better, it makes it easier to match up my code 
 * with the api documentation
 * 
 */
/*************************************************************************
 * GLFW 3.3 - www.glfw.org
 * A library for OpenGL, window and input
 *------------------------------------------------------------------------
 * Copyright (c) 2002-2006 Marcus Geelnard
 * Copyright (c) 2006-2016 Camilla Löwy <elmindreda@glfw.org>
 *
 * This software is provided 'as-is', without any express or implied
 * warranty. In no event will the authors be held liable for any damages
 * arising from the use of this software.
 *
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 *
 * 1. The origin of this software must not be misrepresented; you must not
 *    claim that you wrote the original software. If you use this software
 *    in a product, an acknowledgment in the product documentation would
 *    be appreciated but is not required.
 *
 * 2. Altered source versions must be plainly marked as such, and must not
 *    be misrepresented as being the original software.
 *
 * 3. This notice may not be removed or altered from any source
 *    distribution.
 *
 *************************************************************************/
/** use the loader for the platform - ensure the headers are included in the right order */
#if (__EMSCRIPTEN__) 
[CCode (cprefix = "", lower_case_cprefix ="", cheader_filename="GLES3/gl3.h,GLFW/glfw3.h")]
#else
[CCode (cprefix = "", lower_case_cprefix ="", cheader_filename="glad/glad.h,GLFW/glfw3.h")]
#endif

namespace GLFW {

	/*************************************************************************
	 * GLFW API types
	 *************************************************************************/

	/*! @brief Client API function pointer type.
	 *
	 *  Generic function pointer used for returning client API function pointers
	 *  without forcing a cast from a regular pointer.
	 *
	 *  @sa @ref context_glext
	 *  @sa @ref glfwGetProcAddress
	 *
	 *  @since Added in version 3.0.
	 *
	 *  @ingroup context
	 */
	[CCode (has_target = false)]
	public delegate void GLFWglproc();

	/*! @brief Vulkan API function pointer type.
	 *
	 *  Generic function pointer used for returning Vulkan API function pointers
	 *  without forcing a cast from a regular pointer.
	 *
	 *  @sa @ref vulkan_proc
	 *  @sa @ref glfwGetInstanceProcAddress
	 *
	 *  @since Added in version 3.2.
	 *
	 *  @ingroup vulkan
	 */
	[CCode (has_target = false)]
	public delegate void GLFWvkproc();

	/*! @brief Opaque monitor object.
	 *
	 *  Opaque monitor object.
	 *
	 *  @see @ref monitor_object
	 *
	 *  @since Added in version 3.0.
	 *
	 *  @ingroup monitor
	 */	
 	[SimpleType]
	[CCode (cname = "GLFWmonitor", has_type_id  = false)]
	public struct GLFWmonitor { }

	/*! @brief Opaque window object.
	 *
	 *  Opaque window object.
	 *
	 *  @see @ref window_object
	 *
	 *  @since Added in version 3.0.
	 *
	 *  @ingroup window
	 */
	[SimpleType]
	[CCode (cname = "GLFWwindow", has_type_id  = false)]
	public struct GLFWwindow { }

	/*! @brief Opaque cursor object.
	 *
	 *  Opaque cursor object.
	 *
	 *  @see @ref cursor_object
	 *
	 *  @since Added in version 3.1.
	 *
	 *  @ingroup cursor
	 */
	[SimpleType]
	[CCode (cname = "GLFWcursor", has_type_id  = false)]
	public struct GLFWcursor { }

	/*! @brief The function signature for error callbacks.
	 *
	 *  This is the function signature for error callback functions.
	 *
	 *  @param[in] error An [error code](@ref errors).
	 *  @param[in] description A UTF-8 encoded string describing the error.
	 *
	 *  @sa @ref error_handling
	 *  @sa @ref glfwSetErrorCallback
	 *
	 *  @since Added in version 3.0.
	 *
	 *  @ingroup init
	 */
	[CCode (has_target = false)]
	public delegate void GLFWerrorfun(int code, string desc);

	/*! @brief The function signature for window position callbacks.
	 *
	 *  This is the function signature for window position callback functions.
	 *
	 *  @param[in] window The window that was moved.
	 *  @param[in] xpos The new x-coordinate, in screen coordinates, of the
	 *  upper-left corner of the client area of the window.
	 *  @param[in] ypos The new y-coordinate, in screen coordinates, of the
	 *  upper-left corner of the client area of the window.
	 *
	 *  @sa @ref window_pos
	 *  @sa @ref glfwSetWindowPosCallback
	 *
	 *  @since Added in version 3.0.
	 *
	 *  @ingroup window
	 */
	[CCode (has_target = false)]
	public delegate void GLFWwindowposfun(GLFWwindow* window, int xpos, int ypos);

	/*! @brief The function signature for window resize callbacks.
	 *
	 *  This is the function signature for window size callback functions.
	 *
	 *  @param[in] window The window that was resized.
	 *  @param[in] width The new width, in screen coordinates, of the window.
	 *  @param[in] height The new height, in screen coordinates, of the window.
	 *
	 *  @sa @ref window_size
	 *  @sa @ref glfwSetWindowSizeCallback
	 *
	 *  @since Added in version 1.0.
	 *  @glfw3 Added window handle parameter.
	 *
	 *  @ingroup window
	 */
	[CCode (has_target = false)]
	public delegate void GLFWwindowsizefun(GLFWwindow* window, int width, int height);

	/*! @brief The function signature for window close callbacks.
	 *
	 *  This is the function signature for window close callback functions.
	 *
	 *  @param[in] window The window that the user attempted to close.
	 *
	 *  @sa @ref window_close
	 *  @sa @ref glfwSetWindowCloseCallback
	 *
	 *  @since Added in version 2.5.
	 *  @glfw3 Added window handle parameter.
	 *
	 *  @ingroup window
	 */
	[CCode (has_target = false)]
	public delegate void GLFWwindowclosefun(GLFWwindow* window);

	/*! @brief The function signature for window content refresh callbacks.
	 *
	 *  This is the function signature for window refresh callback functions.
	 *
	 *  @param[in] window The window whose content needs to be refreshed.
	 *
	 *  @sa @ref window_refresh
	 *  @sa @ref glfwSetWindowRefreshCallback
	 *
	 *  @since Added in version 2.5.
	 *  @glfw3 Added window handle parameter.
	 *
	 *  @ingroup window
	 */
	[CCode (has_target = false)]
	public delegate void GLFWwindowrefreshfun(GLFWwindow* window);

	/*! @brief The function signature for window focus/defocus callbacks.
	 *
	 *  This is the function signature for window focus callback functions.
	 *
	 *  @param[in] window The window that gained or lost input focus.
	 *  @param[in] focused `GLFW_TRUE` if the window was given input focus, or
	 *  `GLFW_FALSE` if it lost it.
	 *
	 *  @sa @ref window_focus
	 *  @sa @ref glfwSetWindowFocusCallback
	 *
	 *  @since Added in version 3.0.
	 *
	 *  @ingroup window
	 */
	[CCode (has_target = false)]
	public delegate void GLFWwindowfocusfun(GLFWwindow* window, int focused);

	/*! @brief The function signature for window iconify/restore callbacks.
	 *
	 *  This is the function signature for window iconify/restore callback
	 *  functions.
	 *
	 *  @param[in] window The window that was iconified or restored.
	 *  @param[in] iconified `GLFW_TRUE` if the window was iconified, or
	 *  `GLFW_FALSE` if it was restored.
	 *
	 *  @sa @ref window_iconify
	 *  @sa @ref glfwSetWindowIconifyCallback
	 *
	 *  @since Added in version 3.0.
	 *
	 *  @ingroup window
	 */
	[CCode (has_target = false)]
	public delegate void GLFWwindowiconifyfun(GLFWwindow* window, int iconified);

	/*! @brief The function signature for window maximize/restore callbacks.
	 *
	 *  This is the function signature for window maximize/restore callback
	 *  functions.
	 *
	 *  @param[in] window The window that was maximized or restored.
	 *  @param[in] iconified `GLFW_TRUE` if the window was maximized, or
	 *  `GLFW_FALSE` if it was restored.
	 *
	 *  @sa @ref window_maximize
	 *  @sa glfwSetWindowMaximizeCallback
	 *
	 *  @since Added in version 3.3.
	 *
	 *  @ingroup window
	 */
	[CCode (has_target = false)]
	public delegate void GLFWwindowmaximizefun(GLFWwindow* window, int maximized);

	/*! @brief The function signature for framebuffer resize callbacks.
	 *
	 *  This is the function signature for framebuffer resize callback
	 *  functions.
	 *
	 *  @param[in] window The window whose framebuffer was resized.
	 *  @param[in] width The new width, in pixels, of the framebuffer.
	 *  @param[in] height The new height, in pixels, of the framebuffer.
	 *
	 *  @sa @ref window_fbsize
	 *  @sa @ref glfwSetFramebufferSizeCallback
	 *
	 *  @since Added in version 3.0.
	 *
	 *  @ingroup window
	 */
	[CCode (has_target = false)]
	public delegate void GLFWframebuffersizefun(GLFWwindow* window, int width, int height);

	/*! @brief The function signature for window content scale callbacks.
	 *
	 *  This is the function signature for window content scale callback
	 *  functions.
	 *
	 *  @param[in] window The window whose content scale changed.
	 *  @param[in] xscale The new x-axis content scale of the window.
	 *  @param[in] yscale The new y-axis content scale of the window.
	 *
	 *  @sa @ref window_scale
	 *  @sa @ref glfwSetWindowContentScaleCallback
	 *
	 *  @since Added in version 3.3.
	 *
	 *  @ingroup window
	 */
	[CCode (has_target = false)]
	public delegate void GLFWwindowcontentscalefun(GLFWwindow* window, int xscale, int yscale);

	/*! @brief The function signature for mouse button callbacks.
	 *
	 *  This is the function signature for mouse button callback functions.
	 *
	 *  @param[in] window The window that received the event.
	 *  @param[in] button The [mouse button](@ref buttons) that was pressed or
	 *  released.
	 *  @param[in] action One of `GLFW_PRESS` or `GLFW_RELEASE`.
	 *  @param[in] mods Bit field describing which [modifier keys](@ref mods) were
	 *  held down.
	 *
	 *  @sa @ref input_mouse_button
	 *  @sa @ref glfwSetMouseButtonCallback
	 *
	 *  @since Added in version 1.0.
	 *  @glfw3 Added window handle and modifier mask parameters.
	 *
	 *  @ingroup input
	 */
	[CCode (has_target = false)]
	public delegate void GLFWmousebuttonfun(GLFWwindow* window, int button, int action, int mods);

	/*! @brief The function signature for cursor position callbacks.
	 *
	 *  This is the function signature for cursor position callback functions.
	 *
	 *  @param[in] window The window that received the event.
	 *  @param[in] xpos The new cursor x-coordinate, relative to the left edge of
	 *  the client area.
	 *  @param[in] ypos The new cursor y-coordinate, relative to the top edge of the
	 *  client area.
	 *
	 *  @sa @ref cursor_pos
	 *  @sa @ref glfwSetCursorPosCallback
	 *
	 *  @since Added in version 3.0.  Replaces `GLFWmouseposfun`.
	 *
	 *  @ingroup input
	 */
	[CCode (has_target = false)]
	public delegate void GLFWcursorposfun(GLFWwindow* window, double xpos, double ypos);

	/*! @brief The function signature for cursor enter/leave callbacks.
	 *
	 *  This is the function signature for cursor enter/leave callback functions.
	 *
	 *  @param[in] window The window that received the event.
	 *  @param[in] entered `GLFW_TRUE` if the cursor entered the window's client
	 *  area, or `GLFW_FALSE` if it left it.
	 *
	 *  @sa @ref cursor_enter
	 *  @sa @ref glfwSetCursorEnterCallback
	 *
	 *  @since Added in version 3.0.
	 *
	 *  @ingroup input
	 */
	[CCode (has_target = false)]
	public delegate void GLFWcursorenterfun(GLFWwindow* window, int entered);

	/*! @brief The function signature for scroll callbacks.
	 *
	 *  This is the function signature for scroll callback functions.
	 *
	 *  @param[in] window The window that received the event.
	 *  @param[in] xoffset The scroll offset along the x-axis.
	 *  @param[in] yoffset The scroll offset along the y-axis.
	 *
	 *  @sa @ref scrolling
	 *  @sa @ref glfwSetScrollCallback
	 *
	 *  @since Added in version 3.0.  Replaces `GLFWmousewheelfun`.
	 *
	 *  @ingroup input
	 */
	[CCode (has_target = false)]
	public delegate void GLFWscrollfun(GLFWwindow* window, double xoffset, double yoffset);

	/*! @brief The function signature for keyboard key callbacks.
	 *
	 *  This is the function signature for keyboard key callback functions.
	 *
	 *  @param[in] window The window that received the event.
	 *  @param[in] key The [keyboard key](@ref keys) that was pressed or released.
	 *  @param[in] scancode The system-specific scancode of the key.
	 *  @param[in] action `GLFW_PRESS`, `GLFW_RELEASE` or `GLFW_REPEAT`.
	 *  @param[in] mods Bit field describing which [modifier keys](@ref mods) were
	 *  held down.
	 *
	 *  @sa @ref input_key
	 *  @sa @ref glfwSetKeyCallback
	 *
	 *  @since Added in version 1.0.
	 *  @glfw3 Added window handle, scancode and modifier mask parameters.
	 *
	 *  @ingroup input
	 */
	[CCode (has_target = false)]
	public delegate void GLFWkeyfun(GLFWwindow* window, int key, int scancode, int action, int mods);

	/*! @brief The function signature for Unicode character callbacks.
	 *
	 *  This is the function signature for Unicode character callback functions.
	 *
	 *  @param[in] window The window that received the event.
	 *  @param[in] codepoint The Unicode code point of the character.
	 *
	 *  @sa @ref input_char
	 *  @sa @ref glfwSetCharCallback
	 *
	 *  @since Added in version 2.4.
	 *  @glfw3 Added window handle parameter.
	 *
	 *  @ingroup input
	 */
	[CCode (has_target = false)]
	public delegate void GLFWcharfun(GLFWwindow* window, uint codepoint);

	/*! @brief The function signature for Unicode character with modifiers
	 *  callbacks.
	 *
	 *  This is the function signature for Unicode character with modifiers callback
	 *  functions.  It is called for each input character, regardless of what
	 *  modifier keys are held down.
	 *
	 *  @param[in] window The window that received the event.
	 *  @param[in] codepoint The Unicode code point of the character.
	 *  @param[in] mods Bit field describing which [modifier keys](@ref mods) were
	 *  held down.
	 *
	 *  @sa @ref input_char
	 *  @sa @ref glfwSetCharModsCallback
	 *
	 *  @deprecated Scheduled for removal in version 4.0.
	 *
	 *  @since Added in version 3.1.
	 *
	 *  @ingroup input
	 */
	[CCode (has_target = false)]
	public delegate void GLFWcharmodsfun(GLFWwindow* window, uint codepoint, int modes);

	/*! @brief The function signature for file drop callbacks.
	 *
	 *  This is the function signature for file drop callbacks.
	 *
	 *  @param[in] window The window that received the event.
	 *  @param[in] count The number of dropped files.
	 *  @param[in] paths The UTF-8 encoded file and/or directory path names.
	 *
	 *  @sa @ref path_drop
	 *  @sa @ref glfwSetDropCallback
	 *
	 *  @since Added in version 3.1.
	 *
	 *  @ingroup input
	 */
	[CCode (has_target = false)]
	public delegate void GLFWdropfun(GLFWwindow* window, int count, char** paths);

	/*! @brief The function signature for monitor configuration callbacks.
	 *
	 *  This is the function signature for monitor configuration callback functions.
	 *
	 *  @param[in] monitor The monitor that was connected or disconnected.
	 *  @param[in] event One of `GLFW_CONNECTED` or `GLFW_DISCONNECTED`.  Remaining
	 *  values reserved for future use.
	 *
	 *  @sa @ref monitor_event
	 *  @sa @ref glfwSetMonitorCallback
	 *
	 *  @since Added in version 3.0.
	 *
	 *  @ingroup monitor
	 */
	[CCode (has_target = false)]
	public delegate void GLFWmonitorfun(GLFWmonitor* monitor, int evt);

	/*! @brief The function signature for joystick configuration callbacks.
	 *
	 *  This is the function signature for joystick configuration callback
	 *  functions.
	 *
	 *  @param[in] jid The joystick that was connected or disconnected.
	 *  @param[in] event One of `GLFW_CONNECTED` or `GLFW_DISCONNECTED`.  Remaining
	 *  values reserved for future use.
	 *
	 *  @sa @ref joystick_event
	 *  @sa @ref glfwSetJoystickCallback
	 *
	 *  @since Added in version 3.2.
	 *
	 *  @ingroup input
	 */
	[CCode (has_target = false)]
	public delegate void GLFWjoystickfun(int jid, int evt);

	/*! @brief Video mode type.
	 *
	 *  This describes a single video mode.
	 *
	 *  @sa @ref monitor_modes
	 *  @sa @ref glfwGetVideoMode
	 *  @sa @ref glfwGetVideoModes
	 *
	 *  @since Added in version 1.0.
	 *  @glfw3 Added refresh rate member.
	 *
	 *  @ingroup monitor
	 */
	[SimpleType]
	[CCode (cname = "GLFWvidmode", has_type_id  = false)]
	public struct GLFWvidmode { 
		/*! The width, in screen coordinates, of the video mode.
		 */
		public int width;
		/*! The height, in screen coordinates, of the video mode.
		 */
		public int height;
		/*! The bit depth of the red channel of the video mode.
		 */
		public int redBits;
		/*! The bit depth of the green channel of the video mode.
		 */
		public int greenBits;
		/*! The bit depth of the blue channel of the video mode.
		 */
		public int blueBits;
		/*! The refresh rate, in Hz, of the video mode.
		 */
		public int refreshRate;
	}

	/*! @brief Gamma ramp.
	 *
	 *  This describes the gamma ramp for a monitor.
	 *
	 *  @sa @ref monitor_gamma
	 *  @sa @ref glfwGetGammaRamp
	 *  @sa @ref glfwSetGammaRamp
	 *
	 *  @since Added in version 3.0.
	 *
	 *  @ingroup monitor
	 */
	[SimpleType]
	[CCode (cname = "GLFWgammaramp", has_type_id  = false)]
	public struct GLFWgammaramp { 
		/*! An array of value describing the response of the red channel.
		 */
		[CCode (array_length_cname = "size")]
		public ushort[] red;
		/*! An array of value describing the response of the green channel.
		 */
		[CCode (array_length_cname = "size")]
		public ushort[] green;
		/*! An array of value describing the response of the blue channel.
		 */
		[CCode (array_length_cname = "size")]
		public ushort[] blue;
		/*! The number of elements in each array.
		 */
		public uint size;
	}

	/*! @brief Image data.
	 *
	 *  This describes a single 2D image.  See the documentation for each related
	 *  function what the expected pixel format is.
	 *
	 *  @sa @ref cursor_custom
	 *  @sa @ref window_icon
	 *
	 *  @since Added in version 2.1.
	 *  @glfw3 Removed format and bytes-per-pixel members.
	 */
	[SimpleType]
	[CCode (cname = "GLFWimage", has_type_id  = false)]
	public struct GLFWimage 
	{ 
		/*! The width, in pixels, of this image.
		 */
		public int width;
		/*! The height, in pixels, of this image.
		 */
		public int height;
		/*! The pixel data of this image, arranged left-to-right, top-to-bottom.
		 */
		[CCode (array_length = false)]
		public uchar[] pixels;
	}
	
	/*! @brief Gamepad input state
	 *
	 *  This describes the input state of a gamepad.
	 *
	 *  @sa @ref gamepad
	 *  @sa @ref glfwGetGamepadState
	 *
	 *  @since Added in version 3.3.
	 */
	[SimpleType]
	[CCode (cname = "GLFWgamepadstate", has_type_id  = false)]
	public struct GLFWgamepadstate 
	{ 
		/*! The states of each [gamepad button](@ref gamepad_buttons), `GLFW_PRESS`
		 *  or `GLFW_RELEASE`.
		 */
		public uchar buttons[15];
		/*! Thepublic  states of each [gamepad axis](@ref gamepad_axes), in the range -1.0
		 *  to 1.0 inclusive.
		 */
		public float axes[6];
	}
	
	/*************************************************************************
	 * GLFW API functions
	 *************************************************************************/
	public int glfwInit();
	public void glfwTerminate();
	public void glfwInitHint(int hint, int value);
	public void glfwGetVersion(int* major, int* minor, int* rev);
	public string glfwGetVersionString();
	public int glfwGetError(string description);
	public GLFWerrorfun glfwSetErrorCallback(GLFWerrorfun cbfun);
	public GLFWmonitor** glfwGetMonitors(int* count);
	public GLFWmonitor* glfwGetPrimaryMonitor();
	public void glfwGetMonitorPos(GLFWmonitor* monitor, int* xpos, int* ypos);
	public void glfwGetMonitorPhysicalSize(GLFWmonitor* monitor, int* widthMM, int* heightMM);
	public void glfwGetMonitorContentScale(GLFWmonitor* monitor, float* xscale, float* yscale);
	public string glfwGetMonitorName(GLFWmonitor* monitor);
	public void glfwSetMonitorUserPointer(GLFWmonitor* monitor, void* pointer);
	public void* glfwGetMonitorUserPointer(GLFWmonitor* monitor);
	public GLFWmonitorfun glfwSetMonitorCallback(GLFWmonitorfun cbfun);
	public GLFWvidmode* glfwGetVideoModes(GLFWmonitor* monitor, int* count);
	public void glfwSetGamma(GLFWmonitor* monitor, float gamma);
	public GLFWgammaramp* glfwGetGammaRamp(GLFWmonitor* monitor);
	public void glfwSetGammaRamp(GLFWmonitor* monitor, GLFWgammaramp* ramp);
	public void glfwDefaultWindowHints();
	public void glfwWindowHint(int hint, int value);
	public void glfwWindowHintString(int hint, string value);
	public GLFWwindow* glfwCreateWindow(int width, int height, string title, GLFWmonitor* monitor, GLFWwindow* share);
	public void glfwDestroyWindow(GLFWwindow* window);
	public int glfwWindowShouldClose(GLFWwindow* window);
	public void glfwSetWindowShouldClose(GLFWwindow* window, int value);
	public void glfwSetWindowTitle(GLFWwindow* window, string title);
	public void glfwSetWindowIcon(GLFWwindow* window, int count, GLFWimage* images);
	public void glfwGetWindowPos(GLFWwindow* window, int* xpos, int* ypos);
	public void glfwSetWindowPos(GLFWwindow* window, int xpos, int ypos);
	public void glfwGetWindowSize(GLFWwindow* window, int* width, int* height);
	public void glfwSetWindowSizeLimits(GLFWwindow* window, int minwidth, int minheight, int maxwidth, int maxheight);
	public void glfwSetWindowAspectRatio(GLFWwindow* window, int numer, int denom);
	public void glfwSetWindowSize(GLFWwindow* window, int width, int height);
	public void glfwGetFramebufferSize(GLFWwindow* window, int* width, int* height);
	public void glfwGetWindowFrameSize(GLFWwindow* window, int* left, int* top, int* right, int* bottom);
	public void glfwGetWindowContentScale(GLFWwindow* window, float* xscale, float* yscale);
	public float glfwGetWindowOpacity(GLFWwindow* window);
	public void glfwSetWindowOpacity(GLFWwindow* window, float opacity);
	public void glfwIconifyWindow(GLFWwindow* window);
	public void glfwRestoreWindow(GLFWwindow* window);
	public void glfwMaximizeWindow(GLFWwindow* window);
	public void glfwShowWindow(GLFWwindow* window);
	public void glfwHideWindow(GLFWwindow* window);
	public void glfwFocusWindow(GLFWwindow* window);
	public void glfwRequestWindowAttention(GLFWwindow* window);
	public GLFWmonitor* glfwGetWindowMonitor(GLFWwindow* window);
	public void glfwSetWindowMonitor(GLFWwindow* window, GLFWmonitor* monitor, int xpos, int ypos, int width, int height, int refreshRate);
	public int glfwGetWindowAttrib(GLFWwindow* window, int attrib);
	public void glfwSetWindowAttrib(GLFWwindow* window, int attrib, int value);
	public void glfwSetWindowUserPointer(GLFWwindow* window, void* pointer);
	public void* glfwGetWindowUserPointer(GLFWwindow* window);
	public GLFWwindowposfun glfwSetWindowPosCallback(GLFWwindow* window, GLFWwindowposfun cbfun);
	public GLFWwindowsizefun glfwSetWindowSizeCallback(GLFWwindow* window, GLFWwindowsizefun cbfun);
	public GLFWwindowclosefun glfwSetWindowCloseCallback(GLFWwindow* window, GLFWwindowclosefun cbfun);
	public GLFWwindowrefreshfun glfwSetWindowRefreshCallback(GLFWwindow* window, GLFWwindowrefreshfun cbfun);
	public GLFWwindowfocusfun glfwSetWindowFocusCallback(GLFWwindow* window, GLFWwindowfocusfun cbfun);
	public GLFWwindowiconifyfun glfwSetWindowIconifyCallback(GLFWwindow* window, GLFWwindowiconifyfun cbfun);
	public GLFWwindowmaximizefun glfwSetWindowMaximizeCallback(GLFWwindow* window, GLFWwindowmaximizefun cbfun);
	public GLFWframebuffersizefun glfwSetFramebufferSizeCallback(GLFWwindow* window, GLFWframebuffersizefun cbfun);
	public GLFWwindowcontentscalefun glfwSetWindowContentScaleCallback(GLFWwindow* window, GLFWwindowcontentscalefun cbfun);
	public void glfwPollEvents();
	public void glfwWaitEvents();
	public void glfwWaitEventsTimeout(double timeout);
	public void glfwPostEmptyEvent();
	public int glfwGetInputMode(GLFWwindow* window, int mode);
	public void glfwSetInputMode(GLFWwindow* window, int mode, int value);
	public string glfwGetKeyName(int key, int scancode);
	public int glfwGetKeyScancode(int key);
	public int glfwGetKey(GLFWwindow* window, int key);
	public int glfwGetMouseButton(GLFWwindow* window, int button);
	public void glfwGetCursorPos(GLFWwindow* window, double* xpos, double* ypos);
	public void glfwSetCursorPos(GLFWwindow* window, double xpos, double ypos);
	public GLFWcursor* glfwCreateCursor(GLFWimage* image, int xhot, int yhot);
	public GLFWcursor* glfwCreateStandardCursor(int shape);
	public void glfwDestroyCursor(GLFWcursor* cursor);
	public void glfwSetCursor(GLFWwindow* window, GLFWcursor* cursor);
	public GLFWkeyfun glfwSetKeyCallback(GLFWwindow* window, GLFWkeyfun cbfun);
	public GLFWcharfun glfwSetCharCallback(GLFWwindow* window, GLFWcharfun cbfun);
	public GLFWcharmodsfun glfwSetCharModsCallback(GLFWwindow* window, GLFWcharmodsfun cbfun);
	public GLFWmousebuttonfun glfwSetMouseButtonCallback(GLFWwindow* window, GLFWmousebuttonfun cbfun);
	public GLFWcursorposfun glfwSetCursorPosCallback(GLFWwindow* window, GLFWcursorposfun cbfun);
	public GLFWcursorenterfun glfwSetCursorEnterCallback(GLFWwindow* window, GLFWcursorenterfun cbfun);
	public GLFWscrollfun glfwSetScrollCallback(GLFWwindow* window, GLFWscrollfun cbfun);
	public GLFWdropfun glfwSetDropCallback(GLFWwindow* window, GLFWdropfun cbfun);
	public int glfwJoystickPresent(int jid);
	public float* glfwGetJoystickAxes(int jid, int* count);
	public uchar* glfwGetJoystickButtons(int jid, int* count);
	public uchar* glfwGetJoystickHats(int jid, int* count);
	public string glfwGetJoystickName(int jid);
	public string glfwGetJoystickGUID(int jid);
	public void glfwSetJoystickUserPointer(int jid, void* pointer);
	public void* glfwGetJoystickUserPointer(int jid);
	public int glfwJoystickIsGamepad(int jid);
	public GLFWjoystickfun glfwSetJoystickCallback(GLFWjoystickfun cbfun);
	public int glfwUpdateGamepadMappings(string string);
	public string glfwGetGamepadName(int jid);
	public int glfwGetGamepadState(int jid, GLFWgamepadstate* state);
	public void glfwSetClipboardString(GLFWwindow* window, string string);
	public string glfwGetClipboardString(GLFWwindow* window);
	public double glfwGetTime();
	public void glfwSetTime(double time);
	public uint64 glfwGetTimerValue();
	public uint64 glfwGetTimerFrequency();
	public void glfwMakeContextCurrent(GLFWwindow* window);
	public GLFWwindow* glfwGetCurrentContext();
	public void glfwSwapBuffers(GLFWwindow* window);
	public void glfwSwapInterval(int interval);
	public int glfwExtensionSupported(string extension);
	public GLFWglproc glfwGetProcAddress(string procname);
	public int glfwVulkanSupported();
	public string* glfwGetRequiredInstanceExtensions(uint32* count);

	public const int GLFW_VERSION_MAJOR;
	public const int GLFW_VERSION_MINOR;
	public const int GLFW_VERSION_REVISION;
	public const int GLFW_OPENGL_PROFILE;
	public const int GLFW_OPENGL_CORE_PROFILE;
	public const int GLFW_OPENGL_FORWARD_COMPAT;
	public const int GLFW_CONTEXT_VERSION_MAJOR;
	public const int GLFW_CONTEXT_VERSION_MINOR;


	[CCode (cprefix = "GLFW_", cname = "int", has_type_id = false)]
	public enum ErrorCode {
		NOT_INITIALIZED,
		NO_CURRENT_CONTEXT,
		INVALID_ENUM,
		INVALID_VALUE,
		OUT_OF_MEMORY,
		API_UNAVAILABLE,
		VERSION_UNAVAILABLE,
		PLATFORM_ERROR,
		FORMAT_UNAVAILABLE;
	}

	[CCode (cprefix = "GLFW_", cname = "int", has_type_id = false)]
	public enum InputMode {
		[CCode (cname = "GLFW_CURSOR_MODE")]
		CURSOR,
		STICKY_KEYS,
		STICKY_MOUSE_BUTTONS
	}

	[CCode (cprefix = "GLFW_", cname = "int", has_type_id = false)]
	public enum WindowAttribute {
		// Window attributes
		FOCUSED,
		ICONIFIED,
		VISIBLE,
		RESIZABLE,
		DECORATED,
		// Context attributes
		CLIENT_API,
		CONTEXT_VERSION_MAJOR,
		CONTEXT_VERSION_MINOR,
		CONTEXT_REVISION,
		OPENGL_FORWARD_COMPAT,
		OPENGL_DEBUG_CONTEXT,
		OPENGL_PROFILE,
		CONTEXT_ROBUSTNESS
	}

	[CCode (cprefix = "GLFW_", cname = "int", has_type_id = false)]
	public enum WindowHint {
		RESIZABLE,
		VISIBLE,
		DECORATED,
		RED_BITS,
		GREEN_BITS,
		BLUE_BITS,
		ALPHA_BITS,
		DEPTH_BITS,
		STENCIL_BITS,
		ACCUM_RED_BITS,
		ACCUM_GREEN_BITS,
		ACCUM_BLUE_BITS,
		ACCUM_ALPHA_BITS,
		AUX_BUFFERS,
		SAMPLES,
		REFRESH_RATE,
		STEREO,
		SRGB_CAPABLE,
		CLIENT_API,
		CONTEXT_VERSION_MAJOR,
		CONTEXT_VERSION_MINOR,
		CONTEXT_ROBUSTNESS,
		OPENGL_FORWARD_COMPAT,
		OPENGL_DEBUG_CONTEXT,
		OPENGL_PROFILE;

	}

	[CCode (cname = "int", has_type_id = false)]
	public enum OpenGLProfile {
		[CCode (cname = "GLFW_OPENGL_CORE_PROFILE")]
		CORE,
		[CCode (cname = "GLFW_OPENGL_COMPAT_PROFILE")]
		COMPAT,
		[CCode (cname = "GLFW_OPENGL_ANY_PROFILE")]
		ANY
	}

	[CCode (cname = "int", has_type_id = false)]
	public enum ClientAPI {
		[CCode (cname = "GLFW_OPENGL_API")]
		OPENGL,
		[CCode (cname = "GLFW_OPENGL_ES_API")]
		OPENGL_ES
	}


	[CCode (cname="int", cprefix="GLFW_", has_type_id = false)]
	public enum ButtonState {
		PRESS,
		RELEASE,
		REPEAT
	}

	[CCode (cprefix = "GLFW_MOUSE_BUTTON_", cname="int", has_type_id = false)]
	public enum MouseButton {
		LEFT,
		RIGHT,
		MIDDLE,
		@1,
		@2,
		@3,
		@4,
		@5,
		@6,
		@7,
		@8,
		LAST
	}

	[CCode (cprefix = "GLFW_JOYSTICK_", cname="int", has_type_id = false)]
	public enum Joystick {
		@1,
		@2,
		@3,
		@4,
		@5,
		@6,
		@7,
		@8,
		@9,
		@10,
		@11,
		@12,
		@13,
		@14,
		@15,
		@16,
		LAST
	}

	[CCode (cprefix = "GLFW_MOD_", cname="int", has_type_id = false)]
	[Flags]
	public enum ModifierFlags {
		SHIFT,
		CONTROL,
		ALT,
		SUPER
	}

	[CCode (cprefix = "GLFW_KEY_", cname="int", has_type_id = false)]
	public enum Key {
		UNKNOWN,
		SPACE,
		APOSTROPHE,
		COMMA,
		MINUS,
		PERIOD,
		SLASH,
		@0,
		@1,
		@2,
		@3,
		@4,
		@5,
		@6,
		@7,
		@8,
		@9,
		SEMICOLON,
		EQUAL,
		A,
		B,
		C,
		D,
		E,
		F,
		G,
		H,
		I,
		J,
		K,
		L,
		M,
		N,
		O,
		P,
		Q,
		R,
		S,
		T,
		U,
		V,
		W,
		X,
		Y,
		Z,
		LEFT_BRACKET,
		BACKSLASH,
		RIGHT_BRACKET,
		GRAVE_ACCENT,
		WORLD_1,
		WORLD_2,

		/* Function keys */
		ESCAPE,
		ENTER,
		TAB,
		BACKSPACE,
		INSERT,
		DELETE,
		RIGHT,
		LEFT,
		DOWN,
		UP,
		PAGE_UP,
		PAGE_DOWN,
		HOME,
		END,
		CAPS_LOCK,
		SCROLL_LOCK,
		NUM_LOCK,
		PRINT_SCREEN,
		PAUSE,
		F1,
		F2,
		F3,
		F4,
		F5,
		F6,
		F7,
		F8,
		F9,
		F10,
		F11,
		F12,
		F13,
		F14,
		F15,
		F16,
		F17,
		F18,
		F19,
		F20,
		F21,
		F22,
		F23,
		F24,
		F25,
		KP_0,
		KP_1,
		KP_2,
		KP_3,
		KP_4,
		KP_5,
		KP_6,
		KP_7,
		KP_8,
		KP_9,
		KP_DECIMAL,
		KP_DIVIDE,
		KP_MULTIPLY,
		KP_SUBTRACT,
		KP_ADD,
		KP_ENTER,
		KP_EQUAL,
		LEFT_SHIFT,
		LEFT_CONTROL,
		LEFT_ALT,
		LEFT_SUPER,
		RIGHT_SHIFT,
		RIGHT_CONTROL,
		RIGHT_ALT,
		RIGHT_SUPER,
		MENU,
		LAST
	}
}
