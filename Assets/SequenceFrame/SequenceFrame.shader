// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "SequenceFrame" {
    Properties{
        _MainTex("_MainTex", 2D) = "white" { }//图案
        _RowCnt("_RowCnt", int) = 1
        _ColumnCnt("_ColumnCnt", int) = 1
        _Speed("_Speed", float) = 1
    }
    SubShader
    {
        Tags {"MyType" = "a" "Queue" = "Transparent" "David" = "lalala"}
        Blend SrcAlpha  OneMinusSrcAlpha
    pass
    {
        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag
        #include "UnityCG.cginc"
        sampler2D _MainTex;
        float4 _MainTex_ST;
        int _RowCnt;
        int _ColumnCnt;
        float _Speed;

        struct v2f {
            float4  pos : SV_POSITION;
            float2  uv : TEXCOORD0;
        };

        v2f vert(appdata_base v)
        {
            v2f o;
            o.pos = UnityObjectToClipPos(v.vertex);
            o.uv = TRANSFORM_TEX(v.texcoord,_MainTex);
            return o;
        }

        float4 frag(v2f i) : COLOR
        {
            float cell_size_x = 1.0 / _ColumnCnt;
            float cell_size_y = 1.0 / _RowCnt;

            int total_cnt = _ColumnCnt * _RowCnt;
            int cur_sprite_idx = floor(_Time.y * _Speed % total_cnt);

            int cur_sprite_idx_x = cur_sprite_idx % _ColumnCnt;
            int cur_sprite_idx_y = cur_sprite_idx % _RowCnt;

            float2 new_uv;
            new_uv.x = cell_size_x * cur_sprite_idx_x + cell_size_x * i.uv.x;
            new_uv.y = cell_size_y * cur_sprite_idx_y + cell_size_y * i.uv.y;

            float4 color_Tex = tex2D(_MainTex, new_uv);
            return color_Tex;
        }
        ENDCG
    }
    }
}