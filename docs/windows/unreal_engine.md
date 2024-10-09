# Unreal Engine Project Setup with Visual Studio 2022

This document outlines the core asset types used in Unreal Engine, providing an overview for working with **Visual Studio 2022**.

## Key Asset Types in Unreal Engine

### 1. Blueprints

Blueprints are visual scripting assets that empower designers and developers to create gameplay mechanics, animations, and user interfaces without writing code. The primary types of Blueprints include:

- **Blueprint Class**: The most versatile type, used for creating gameplay elements like characters, weapons, and interactive items.
- **Animation Blueprint**: Controls the animation logic for characters or creatures, typically involving skeletal meshes.
- **Widget Blueprint**: Used to design and implement user interfaces (UI), such as menus, HUDs, and buttons.

### 2. Materials

Materials dictate how surfaces look by controlling their interaction with light, texture, and shading in Unreal Engine.

- **Material**: Defines the surface properties, including color, roughness, and reflectivity. Materials are applied to meshes to control their appearance.
- **Material Function**: A reusable block of material code that can be shared across different materials, simplifying the creation process.
- **Material Instance**: A specialized material where certain parameters (like color or texture) can be modified without needing to duplicate the entire material.

### 3. Meshes

Meshes are the 3D geometric representations of objects in Unreal Engine.

- **Static Mesh**: A non-animated 3D model, typically used for buildings, props, or other environment elements.
- **Skeletal Mesh**: A mesh associated with a skeleton, used for characters or objects that require animation.
- **Physical Asset**: Defines how a skeletal mesh reacts to physics, such as collisions or ragdoll effects.
- **Skeleton**: The bone structure attached to a skeletal mesh, allowing for animations like walking or jumping.

### 4. Levels

Levels, often referred to as maps, are the 3D environments where gameplay occurs. They contain everything from terrain and static meshes to actors and gameplay logic.

- **Level**: Represents a game environment, including all its geometry, actors, and scripts, acting as the backdrop for gameplay.

### 5. Data Assets

Data Assets are used to store and manage structured data, such as character attributes, item statistics, or game configuration settings.

- **Data Asset**: A customizable asset that holds data in a structured way, making it easy to access from gameplay code or Blueprints.

### 6. Niagara (Visual Effects System)

Niagara is Unreal Engine's advanced system for creating particle effects such as explosions, smoke, or fire. It is highly flexible and supports complex visual effects.

- **Niagara Effect Type**: Defines overarching Niagara settings, typically used to manage large-scale systems for multiple effects.
- **Niagara System**: A group of emitters and settings that create specific visual effects, like a fire or explosion.
- **Niagara Module**: A reusable piece of Niagara logic that controls aspects of particle behavior, such as velocity or color changes.

### 7. Animation

Animation assets help bring life to skeletal meshes, providing movement and interaction with the game world.

- **Control Rig**: A procedural animation system that allows for rigging and animation of characters directly within Unreal Engine, enabling complex animation controls and behaviors.

### 8. Textures

Textures are image files that provide details like color, patterns, or bumps for surfaces in the game world.

- **Texture**: An image or bitmap applied to a material to provide surface detail, such as a wood grain, stone pattern, or metal shine.

### 9. C++ Classes

C++ allows developers to write more complex and performance-optimized game logic, extending beyond what is possible in Blueprints.

- **C++ Class**: The core building block for creating custom gameplay functionality, such as AI behavior, game systems, or performance-critical components, using the C++ programming language.
