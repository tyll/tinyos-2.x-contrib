#ifndef COMPONENTS_H
#define COMPONENTS_H


#define DEF_COMPONENTS(name, pr) components pr as PR_##name;

#define SIMPLE_PRIM_CONFIG(name, pr)  App.Primitive[name] -> PR_##name;
#define EVAL_PRIM_CONFIG(name, pr)    App.Eval[name]      -> PR_##name;
#define APPLY_PRIM_CONFIG(name, pr)   App.Apply[name]     -> PR_##name;
#define SEND_PRIM_CONFIG(name, pr)    App.Sender[name]    -> PR_##name;
#define RECEIVER_CONFIG(name, pr)     App.Receiver[name]  -> PR_##name;

#endif // COMPONENTS_H
